//
//  ProductDetailViewModel.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation

final class ProductDetailViewModel {
    let product: Product
    let currencyCode: String = "USD"

    init(product: Product) {
        self.product = product
    }

    var galleryImages: [String] {
        product.images.isEmpty ? [product.thumbnail] : product.images
    }

    var hasDiscount: Bool {
        product.discountPercentage > 0
    }

    var discountedPrice: Double {
        product.price * (1 - product.discountPercentage / 100)
    }

    var averageReviewRating: Double {
        guard !product.reviews.isEmpty else { return product.rating }
        let total = product.reviews.reduce(0) { $0 + Double($1.rating) }
        return total / Double(product.reviews.count)
    }

    var availabilityStatus: String {
        product.availabilityStatus
    }
}
