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

    init(viewModel: ProductListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Productos")
                .task {
                    await viewModel.load()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundStyle(.secondary)
        } else {
            List(viewModel.products) { product in
                VStack(alignment: .leading) {
                    Text(product.title)
                        .font(.headline)
                    Text(product.brand ?? product.category)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
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

#Preview {
    ProductListView(viewModel: makePreviewViewModel())
}
