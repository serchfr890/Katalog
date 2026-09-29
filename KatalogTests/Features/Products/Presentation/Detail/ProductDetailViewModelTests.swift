//
//  ProductDetailViewModelTests.swift
//  KatalogTests
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation
import Testing
@testable import Katalog

struct ProductDetailViewModelTests {

    @Test func hasDiscountIsTrueWhenPercentageIsPositive() {
        let viewModel = ProductDetailViewModel(product: makeProduct(discountPercentage: 15))
        #expect(viewModel.hasDiscount == true)
    }

    @Test func hasDiscountIsFalseWhenPercentageIsZero() {
        let viewModel = ProductDetailViewModel(product: makeProduct(discountPercentage: 0))
        #expect(viewModel.hasDiscount == false)
    }

    @Test func discountedPriceAppliesPercentageToPrice() {
        let viewModel = ProductDetailViewModel(product: makeProduct(price: 100, discountPercentage: 25))
        #expect(viewModel.discountedPrice == 75)
    }

    @Test func galleryImagesReturnsImagesWhenNotEmpty() {
        let viewModel = ProductDetailViewModel(
            product: makeProduct(images: ["a.png", "b.png"], thumbnail: "thumb.png")
        )
        #expect(viewModel.galleryImages == ["a.png", "b.png"])
    }

    @Test func galleryImagesFallsBackToThumbnailWhenImagesEmpty() {
        let viewModel = ProductDetailViewModel(product: makeProduct(images: [], thumbnail: "thumb.png"))
        #expect(viewModel.galleryImages == ["thumb.png"])
    }

    @Test func averageReviewRatingAveragesReviewRatings() {
        let viewModel = ProductDetailViewModel(
            product: makeProduct(rating: 4.0, reviews: [
                makeReview(rating: 5),
                makeReview(rating: 3)
            ])
        )
        #expect(viewModel.averageReviewRating == 4.0)
    }

    @Test func averageReviewRatingFallsBackToProductRatingWhenNoReviews() {
        let viewModel = ProductDetailViewModel(product: makeProduct(rating: 4.2, reviews: []))
        #expect(viewModel.averageReviewRating == 4.2)
    }

    @Test func availabilityStatusReflectsProductValue() {
        let viewModel = ProductDetailViewModel(product: makeProduct(availabilityStatus: "Low Stock"))
        #expect(viewModel.availabilityStatus == "Low Stock")
    }
}

private func makeProduct(
    price: Double = 10,
    discountPercentage: Double = 0,
    rating: Double = 4.5,
    availabilityStatus: String = "In Stock",
    reviews: [Review] = [],
    images: [String] = ["image.png"],
    thumbnail: String = "thumbnail.png"
) -> Product {
    Product(
        id: 1,
        title: "Producto de prueba",
        description: "Descripción de prueba",
        category: "demo",
        price: price,
        discountPercentage: discountPercentage,
        rating: rating,
        stock: 10,
        tags: [],
        brand: "Marca",
        sku: "SKU-1",
        weight: 1,
        dimensions: Dimensions(width: 1, height: 1, depth: 1),
        warrantyInformation: "1 año",
        shippingInformation: "Envío en 3 días",
        availabilityStatus: availabilityStatus,
        reviews: reviews,
        returnPolicy: "30 días",
        minimumOrderQuantity: 1,
        meta: Meta(createdAt: .now, updatedAt: .now, barcode: "123", qrCode: "qr"),
        images: images,
        thumbnail: thumbnail
    )
}

private func makeReview(rating: Int) -> Review {
    Review(
        rating: rating,
        comment: "Comentario de prueba",
        date: .now,
        reviewerName: "Reviewer",
        reviewerEmail: "reviewer@example.com"
    )
}
