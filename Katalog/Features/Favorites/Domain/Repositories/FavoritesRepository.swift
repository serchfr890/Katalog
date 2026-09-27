//
//  FavoritesRepository.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation

protocol FavoritesRepository {
    func getFavoriteIds() async throws -> Set<Int>
    func setFavorite(productId: Int, isFavorite: Bool) async throws
}
