//
//  FavoritesStore.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation

@MainActor
@Observable
final class FavoritesStore {
    private(set) var favoriteIds: Set<Int> = []

    private let repository: FavoritesRepository

    init(repository: FavoritesRepository) {
        self.repository = repository
    }

    func load() async {
        favoriteIds = (try? await repository.getFavoriteIds()) ?? []
    }

    func isFavorite(_ productId: Int) -> Bool {
        favoriteIds.contains(productId)
    }

    func toggle(_ productId: Int) {
        let isNowFavorite = !favoriteIds.contains(productId)
        if isNowFavorite {
            favoriteIds.insert(productId)
        } else {
            favoriteIds.remove(productId)
        }
        Task {
            try? await repository.setFavorite(productId: productId, isFavorite: isNowFavorite)
        }
    }
}
