import Foundation

nonisolated struct Product: Codable, Identifiable, Hashable, Sendable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let tags: [String]
    let brand: String?
    let sku: String
    let weight: Double
    let dimensions: Dimensions
    let warrantyInformation: String
    let shippingInformation: String
    let availabilityStatus: String
    let reviews: [Review]
    let returnPolicy: String
    let minimumOrderQuantity: Int
    let meta: Meta
    let images: [String]
    let thumbnail: String
}

nonisolated struct Dimensions: Codable, Hashable, Sendable {
    let width: Double
    let height: Double
    let depth: Double
}

nonisolated struct Review: Codable, Hashable, Sendable {
    let rating: Int
    let comment: String
    let date: Date
    let reviewerName: String
    let reviewerEmail: String
}

nonisolated struct Meta: Codable, Hashable, Sendable {
    let createdAt: Date
    let updatedAt: Date
    let barcode: String
    let qrCode: String
}
