//
//  ProductDetailView.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import SwiftData
import SwiftUI

struct ProductDetailView: View {
    @State private var viewModel: ProductDetailViewModel
    @State private var isDescriptionExpanded = false

    @Environment(\.dismiss) private var dismiss

    private let descriptionPreviewLength = 100
    let favoritesStore: FavoritesStore

    init(
        product: Product,
        favoritesStore: FavoritesStore
    ) {
        viewModel = ProductDetailViewModel(product: product)
        self.favoritesStore = favoritesStore
    }

    private var availabilityColor: Color {
        switch viewModel.availabilityStatus {
        case "In Stock":
            return .green
        case "Low Stock":
            return .orange
        default:
            return .red
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                galleryView
                mainInfoView
                descriptionView
                reviewsView
            }
            .padding(.bottom, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                FavoriteButtonView(productId: viewModel.product.id, store: favoritesStore)
            }
        }
    }

    private var galleryView: some View {
        TabView {
            ForEach(viewModel.galleryImages, id: \.self) { imageURLString in
                AsyncImage(url: URL(string: imageURLString)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    default:
                        Color(.systemGray5)
                    }
                }
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .frame(height: 320)
    }

    private var mainInfoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.product.title)
                .font(.title2)
                .fontWeight(.semibold)

            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text(viewModel.product.rating.formatted(.number.precision(.fractionLength(1))))
                    .foregroundStyle(.secondary)

                if viewModel.hasDiscount {
                    Text("-\(viewModel.product.discountPercentage.formatted(.number.precision(.fractionLength(0))))%")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.red.gradient, in: .capsule)
                }
            }
            .font(.subheadline)

            priceView

            Label(viewModel.product.availabilityStatus, systemImage: "shippingbox")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(availabilityColor)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var priceView: some View {
        if viewModel.hasDiscount {
            HStack(spacing: 8) {
                Text(viewModel.discountedPrice.formatted(.currency(code: viewModel.currencyCode)))
                    .font(.title3)
                    .fontWeight(.bold)
                Text(viewModel.product.price.formatted(.currency(code: viewModel.currencyCode)))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .strikethrough()
            }
        } else {
            Text(viewModel.product.price.formatted(.currency(code: viewModel.currencyCode)))
                .font(.title3)
                .fontWeight(.bold)
        }
    }

    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Descripción")
                .font(.headline)

            Text(isDescriptionExpanded ? viewModel.product.description : descriptionPreview)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if viewModel.product.description.count > descriptionPreviewLength {
                Button(isDescriptionExpanded ? "Ver menos" : "Ver más") {
                    withAnimation {
                        isDescriptionExpanded.toggle()
                    }
                }
                .font(.caption)
                .fontWeight(.semibold)
            }
        }
        .padding(.horizontal)
    }

    private var descriptionPreview: String {
        if viewModel.product.description.count > descriptionPreviewLength {
            return String(viewModel.product.description.prefix(descriptionPreviewLength)) + "…"
        }
        return viewModel.product.description
    }

    private var reviewsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Comentarios")
                    .font(.headline)
                Spacer()
                if !viewModel.product.reviews.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text(viewModel.averageReviewRating.formatted(.number.precision(.fractionLength(1))))
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                }
            }
            .padding(.horizontal)

            if viewModel.product.reviews.isEmpty {
                Text("Aún no hay comentarios.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 12) {
                        ForEach(Array(viewModel.product.reviews.enumerated()), id: \.offset) { _, review in
                            ReviewCardView(review: review)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

private struct ReviewCardView: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(review.reviewerName)
                .font(.subheadline)
                .fontWeight(.semibold)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(.caption)
                Text("\(review.rating)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(review.date.formatted(date: .abbreviated, time: .shortened))
                .font(.caption2)
                .foregroundStyle(.secondary)

            Text(review.comment)
                .font(.caption)
                .lineLimit(4)
        }
        .padding(12)
        .frame(width: 220, alignment: .leading)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
    }
}

private func makePreviewFavoritesStore() -> FavoritesStore {
    let modelContainer: ModelContainer
    do {
        modelContainer = try ModelContainer(
            for: FavoriteEntity.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    } catch {
        fatalError("No se pudo inicializar el ModelContainer de preview: \(error)")
    }
    let localDataSource = FavoritesLocalDataSourceImpl(modelContainer: modelContainer)
    return FavoritesStore(repository: FavoritesRepositoryImpl(localDataSource: localDataSource))
}

private func makePreviewProductView() -> Product {
    return Product(
        id: 1,
        title: "Producto de ejemplo",
        description: String(repeating: "Descripción de ejemplo. ", count: 10),
        category: "demo",
        price: 99.99,
        discountPercentage: 12,
        rating: 4.3,
        stock: 10,
        tags: [],
        brand: "Marca",
        sku: "SKU-1",
        weight: 1,
        dimensions: Dimensions(width: 1, height: 1, depth: 1),
        warrantyInformation: "1 año",
        shippingInformation: "Envío en 3 días",
        availabilityStatus: "In Stock",
        reviews: [
            Review(
                rating: 5,
                comment: "Excelente producto, muy recomendado.",
                date: .now,
                reviewerName: "Ana",
                reviewerEmail: "ana@example.com"
            ),
            Review(
                rating: 3,
                comment: "Cumple, pero esperaba más calidad.",
                date: .now,
                reviewerName: "Luis",
                reviewerEmail: "luis@example.com"
            )
        ],
        returnPolicy: "30 días",
        minimumOrderQuantity: 1,
        meta: Meta(createdAt: .now, updatedAt: .now, barcode: "123", qrCode: "qr"),
        images: [],
        thumbnail: ""
    )
}

#Preview {
    NavigationStack {
        ProductDetailView(
            product: makePreviewProductView(),
            favoritesStore: makePreviewFavoritesStore()
        )
    }
}
