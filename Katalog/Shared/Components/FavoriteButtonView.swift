//
//  FavoriteButtonView.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import SwiftUI

struct FavoriteButtonView: View {
    let productId: Int
    let store: FavoritesStore

    var body: some View {
        Button {
            store.toggle(productId)
        } label: {
            Image(systemName: store.isFavorite(productId) ? "heart.fill" : "heart")
                .foregroundStyle(store.isFavorite(productId) ? .red : .secondary)
        }
        .buttonStyle(.plain)
    }
}
