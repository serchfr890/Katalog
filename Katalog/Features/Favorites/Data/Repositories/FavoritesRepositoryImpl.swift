//
//  FavoritesRepositoryImpl.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation

final class FavoritesRepositoryImpl: FavoritesRepository {
    private let localDataSource: FavoritesLocalDataSource

    init(localDataSource: FavoritesLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func getFavoriteIds() async throws -> Set<Int> {
        try await localDataSource.fetchAllIds()
    }

    func setFavorite(productId: Int, isFavorite: Bool) async throws {
        if isFavorite {
            try await localDataSource.add(productId: productId)
        } else {
            try await localDataSource.remove(productId: productId)
        }
    }
}
