//
//  ProductLocalDataSource.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation
import SwiftData

protocol ProductLocalDataSource: Sendable {
    func fetchAll() async throws -> [Product]
    func fetch(id: Int) async throws -> Product?
    func save(_ products: [Product]) async throws
    func save(_ product: Product) async throws
}

@ModelActor
actor ProductLocalDataSourceImpl: ProductLocalDataSource {
    func fetchAll() throws -> [Product] {
        let descriptor = FetchDescriptor<ProductEntity>(sortBy: [SortDescriptor(\.id)])
        return try modelContext.fetch(descriptor).map { $0.toDomain() }
    }

    func fetch(id: Int) throws -> Product? {
        let descriptor = FetchDescriptor<ProductEntity>(predicate: #Predicate { $0.id == id })
        return try modelContext.fetch(descriptor).first?.toDomain()
    }

    func save(_ products: [Product]) throws {
        for product in products {
            try upsert(product)
        }
        try modelContext.save()
    }

    func save(_ product: Product) throws {
        try upsert(product)
        try modelContext.save()
    }

    private func upsert(_ product: Product) throws {
        let productId = product.id
        let descriptor = FetchDescriptor<ProductEntity>(predicate: #Predicate { $0.id == productId })
        if let existing = try modelContext.fetch(descriptor).first {
            existing.update(from: product)
        } else {
            modelContext.insert(ProductEntity(product: product))
        }
    }
}
