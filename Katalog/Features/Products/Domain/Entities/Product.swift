import Foundation

struct Product: Codable, Identifiable, Hashable {
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

struct Dimensions: Codable, Hashable {
    let width: Double
    let height: Double
    let depth: Double
}

struct Review: Codable, Hashable {
    let rating: Int
    let comment: String
    let date: Date
    let reviewerName: String
    let reviewerEmail: String
}

struct Meta: Codable, Hashable {
    let createdAt: Date
    let updatedAt: Date
    let barcode: String
    let qrCode: String
}
