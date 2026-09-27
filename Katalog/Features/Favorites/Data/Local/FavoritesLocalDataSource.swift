//
//  FavoritesLocalDataSource.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation
import SwiftData

protocol FavoritesLocalDataSource: Sendable {
    func fetchAllIds() async throws -> Set<Int>
    func add(productId: Int) async throws
    func remove(productId: Int) async throws
}

@ModelActor
actor FavoritesLocalDataSourceImpl: FavoritesLocalDataSource {
    func fetchAllIds() throws -> Set<Int> {
        let descriptor = FetchDescriptor<FavoriteEntity>()
        return Set(try modelContext.fetch(descriptor).map { $0.productId })
    }

    func add(productId: Int) throws {
        let descriptor = FetchDescriptor<FavoriteEntity>(predicate: #Predicate { $0.productId == productId })
        guard try modelContext.fetch(descriptor).isEmpty else { return }
        modelContext.insert(FavoriteEntity(productId: productId))
        try modelContext.save()
    }

    func remove(productId: Int) throws {
        let descriptor = FetchDescriptor<FavoriteEntity>(predicate: #Predicate { $0.productId == productId })
        guard let existing = try modelContext.fetch(descriptor).first else { return }
        modelContext.delete(existing)
        try modelContext.save()
    }
}
