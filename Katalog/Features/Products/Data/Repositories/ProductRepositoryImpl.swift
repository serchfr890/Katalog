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

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getProducts() async throws -> [Product] {
        let url = baseURL.appendingPathComponent("products")
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        return try Self.decoder.decode(ProductsResponse.self, from: data).products
    }

    func getProduct(id: Int) async throws -> Product {
        let url = baseURL
            .appendingPathComponent("products")
            .appendingPathComponent("\(id)")
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        return try Self.decoder.decode(Product.self, from: data)
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
