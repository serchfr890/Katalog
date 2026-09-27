//
//  ProductEntity.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation
import SwiftData

@Model
final class ProductEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var productDescription: String
    var category: String
    var price: Double
    var discountPercentage: Double
    var rating: Double
    var stock: Int
    var tags: [String]
    var brand: String?
    var sku: String
    var weight: Double
    private var dimensionsData: Data
    var warrantyInformation: String
    var shippingInformation: String
    var availabilityStatus: String
    private var reviewsData: Data
    var returnPolicy: String
    var minimumOrderQuantity: Int
    private var metaData: Data
    var images: [String]
    var thumbnail: String

    var dimensions: Dimensions {
        get { Self.decode(dimensionsData) }
        set { dimensionsData = Self.encode(newValue) }
    }

    var reviews: [Review] {
        get { Self.decode(reviewsData) }
        set { reviewsData = Self.encode(newValue) }
    }

    var meta: Meta {
        get { Self.decode(metaData) }
        set { metaData = Self.encode(newValue) }
    }

    init(product: Product) {
        id = product.id
        title = product.title
        productDescription = product.description
        category = product.category
        price = product.price
        discountPercentage = product.discountPercentage
        rating = product.rating
        stock = product.stock
        tags = product.tags
        brand = product.brand
        sku = product.sku
        weight = product.weight
        dimensionsData = Self.encode(product.dimensions)
        warrantyInformation = product.warrantyInformation
        shippingInformation = product.shippingInformation
        availabilityStatus = product.availabilityStatus
        reviewsData = Self.encode(product.reviews)
        returnPolicy = product.returnPolicy
        minimumOrderQuantity = product.minimumOrderQuantity
        metaData = Self.encode(product.meta)
        images = product.images
        thumbnail = product.thumbnail
    }

    func update(from product: Product) {
        title = product.title
        productDescription = product.description
        category = product.category
        price = product.price
        discountPercentage = product.discountPercentage
        rating = product.rating
        stock = product.stock
        tags = product.tags
        brand = product.brand
        sku = product.sku
        weight = product.weight
        dimensions = product.dimensions
        warrantyInformation = product.warrantyInformation
        shippingInformation = product.shippingInformation
        availabilityStatus = product.availabilityStatus
        reviews = product.reviews
        returnPolicy = product.returnPolicy
        minimumOrderQuantity = product.minimumOrderQuantity
        meta = product.meta
        images = product.images
        thumbnail = product.thumbnail
    }

    func toDomain() -> Product {
        Product(
            id: id,
            title: title,
            description: productDescription,
            category: category,
            price: price,
            discountPercentage: discountPercentage,
            rating: rating,
            stock: stock,
            tags: tags,
            brand: brand,
            sku: sku,
            weight: weight,
            dimensions: dimensions,
            warrantyInformation: warrantyInformation,
            shippingInformation: shippingInformation,
            availabilityStatus: availabilityStatus,
            reviews: reviews,
            returnPolicy: returnPolicy,
            minimumOrderQuantity: minimumOrderQuantity,
            meta: meta,
            images: images,
            thumbnail: thumbnail
        )
    }

    private static func encode<T: Encodable>(_ value: T) -> Data {
        // swiftlint:disable:next force_try
        try! JSONEncoder().encode(value)
    }

    private static func decode<T: Decodable>(_ data: Data) -> T {
        // swiftlint:disable:next force_try
        try! JSONDecoder().decode(T.self, from: data)
    }
}
