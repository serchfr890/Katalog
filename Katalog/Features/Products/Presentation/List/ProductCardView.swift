//
//  ProductCardView.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    let favoritesStore: FavoritesStore
    let currencyCode: String = "USD"

    private var hasDiscount: Bool {
        product.discountPercentage > 0
    }

    private var discountedPrice: Double {
        product.price * (1 - product.discountPercentage / 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            thumbnailView
            productTitleView
            rateView
            priceView
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }

    private var thumbnailView: some View {
        AsyncImage(url: URL(string: product.thumbnail)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            default:
                Color(.systemGray5)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(alignment: .topTrailing) {
            FavoriteButtonView(productId: product.id, store: favoritesStore)
                .padding(6)
                .background(.white.opacity(0.85), in: .circle)
                .padding(6)
        }
    }

    @ViewBuilder
    private var productTitleView: some View {
        Text(product.title)
            .font(.subheadline)
            .fontWeight(.medium)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
    }

    @ViewBuilder
    private var rateView: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
                .font(.caption)
            Text(product.rating.formatted(.number.precision(.fractionLength(1))))
                .font(.caption)
                .foregroundStyle(.secondary)

            if hasDiscount {
                Spacer()
                Text("-\(product.discountPercentage.formatted(.number.precision(.fractionLength(0))))%")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.red.gradient, in: .capsule)
            }
        }
    }

    @ViewBuilder
    private var priceView: some View {
        if hasDiscount {
            HStack(spacing: 6) {
                Text(discountedPrice.formatted(.currency(code: currencyCode)))
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(product.price.formatted(.currency(code: currencyCode)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .strikethrough()
            }
        } else {
            Text(product.price.formatted(.currency(code: currencyCode)))
                .font(.subheadline)
                .fontWeight(.bold)
        }
    }
}
