//
//  ProductRepositoryImpl.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation

final class ProductRepositoryImpl: ProductRepository {
    private let baseURL = URL(string: "https://dummyjson.com")!
    private let session: URLSession
    private let localDataSource: ProductLocalDataSource

    init(session: URLSession = .shared, localDataSource: ProductLocalDataSource) {
        self.session = session
        self.localDataSource = localDataSource
    }

    func getProducts() async throws -> [Product] {
        let cached = try await localDataSource.fetchAll()
        if !cached.isEmpty {
            return cached
        }
        return try await refreshProducts()
    }

    func refreshProducts() async throws -> [Product] {
        let url = baseURL.appendingPathComponent("products")
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        let products = try Self.decoder.decode(ProductsResponse.self, from: data).products
        try await localDataSource.save(products)
        return products
    }

    func getProduct(id: Int) async throws -> Product {
        if let cached = try await localDataSource.fetch(id: id) {
            return cached
        }
        let url = baseURL
            .appendingPathComponent("products")
            .appendingPathComponent("\(id)")
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        let product = try Self.decoder.decode(Product.self, from: data)
        try await localDataSource.save(product)
        return product
    }

    private static func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom { dec in
            let container = try dec.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = formatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Fecha inválida: \(dateString)")
            }
            return date
        }
        return decoder
    }()
}
