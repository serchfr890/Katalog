//
//  ProductListView.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import SwiftData
import SwiftUI

struct ProductListView: View {
    @State private var viewModel: ProductListViewModel
    let favoritesStore: FavoritesStore

    init(viewModel: ProductListViewModel, favoritesStore: FavoritesStore) {
        _viewModel = State(initialValue: viewModel)
        self.favoritesStore = favoritesStore
    }

    private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Browse catalog")
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always)
                )
                .navigationDestination(for: Product.self) { product in
                    ProductDetailView(product: product, favoritesStore: favoritesStore)
                }
                .task {
                    await viewModel.load()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.products.isEmpty {
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 16) {
                    ForEach(0..<6, id: \.self) { _ in
                        ProductCardSkeletonView()
                    }
                }
                .padding(.horizontal)
            }
        } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundStyle(.secondary)
        } else {
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 16) {
                    ForEach(viewModel.filteredProducts) { product in
                        NavigationLink(value: product) {
                            ProductCardView(product: product, favoritesStore: favoritesStore)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

private func makePreviewViewModel() -> ProductListViewModel {
    let modelContainer: ModelContainer
    do {
        modelContainer = try ModelContainer(
            for: ProductEntity.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    } catch {
        fatalError("No se pudo inicializar el ModelContainer de preview: \(error)")
    }
    let localDataSource = ProductLocalDataSourceImpl(modelContainer: modelContainer)
    return ProductListViewModel(
        fetchProductsUseCase: FetchProductsUseCaseImpl(
            repository: ProductRepositoryImpl(localDataSource: localDataSource)
        )
    )
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

#Preview {
    ProductListView(viewModel: makePreviewViewModel(), favoritesStore: makePreviewFavoritesStore())
}
