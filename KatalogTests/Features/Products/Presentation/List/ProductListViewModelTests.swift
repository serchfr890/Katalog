//
//  ProductListViewModelTests.swift
//  KatalogTests
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation
import Testing
@testable import Katalog

@MainActor
struct ProductListViewModelTests {

    @Test func initialStateIsEmpty() {
        let viewModel = ProductListViewModel(fetchProductsUseCase: FakeFetchProductsUseCase())
        #expect(viewModel.products.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.searchText.isEmpty)
    }

    @Test func loadUsesRefreshResultWhenBothSucceed() async {
        let useCase = FakeFetchProductsUseCase(
            executeResult: .success([makeProduct(id: 1, title: "Cached")]),
            refreshResult: .success([makeProduct(id: 2, title: "Fresh")])
        )
        let viewModel = ProductListViewModel(fetchProductsUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.products.map(\.id) == [2])
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test func loadRecoversWhenExecuteFailsButRefreshSucceeds() async {
        let useCase = FakeFetchProductsUseCase(
            executeResult: .failure(URLError(.notConnectedToInternet)),
            refreshResult: .success([makeProduct(id: 3, title: "Remote")])
        )
        let viewModel = ProductListViewModel(fetchProductsUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.products.map(\.id) == [3])
        #expect(viewModel.errorMessage == nil)
    }

    @Test func loadKeepsCachedProductsWhenRefreshFails() async {
        let useCase = FakeFetchProductsUseCase(
            executeResult: .success([makeProduct(id: 4, title: "Cached")]),
            refreshResult: .failure(URLError(.notConnectedToInternet))
        )
        let viewModel = ProductListViewModel(fetchProductsUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.products.map(\.id) == [4])
        #expect(viewModel.errorMessage == nil)
    }

    @Test func loadSetsErrorMessageWhenBothExecuteAndRefreshFail() async {
        let useCase = FakeFetchProductsUseCase(
            executeResult: .failure(URLError(.notConnectedToInternet)),
            refreshResult: .failure(URLError(.notConnectedToInternet))
        )
        let viewModel = ProductListViewModel(fetchProductsUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.products.isEmpty)
        #expect(viewModel.errorMessage == "No se pudieron cargar los productos.")
    }

    @Test func filteredProductsReturnsAllWhenSearchTextIsEmpty() async {
        let useCase = FakeFetchProductsUseCase(
            executeResult: .success([makeProduct(id: 1, title: "Silla")]),
            refreshResult: .success([
                makeProduct(id: 1, title: "Silla"),
                makeProduct(id: 2, title: "Mesa")
            ])
        )
        let viewModel = ProductListViewModel(fetchProductsUseCase: useCase)
        await viewModel.load()

        #expect(viewModel.filteredProducts.count == 2)
    }

    @Test func filteredProductsFiltersByTitleCaseInsensitively() async {
        let useCase = FakeFetchProductsUseCase(
            executeResult: .success([]),
            refreshResult: .success([
                makeProduct(id: 1, title: "Silla de oficina"),
                makeProduct(id: 2, title: "Mesa de centro")
            ])
        )
        let viewModel = ProductListViewModel(fetchProductsUseCase: useCase)
        await viewModel.load()

        viewModel.searchText = "SILLA"

        #expect(viewModel.filteredProducts.map(\.id) == [1])
    }
}

private final class FakeFetchProductsUseCase: FetchProductsUseCase {
    private let executeResult: Result<[Product], Error>
    private let refreshResult: Result<[Product], Error>

    init(
        executeResult: Result<[Product], Error> = .success([]),
        refreshResult: Result<[Product], Error> = .success([])
    ) {
        self.executeResult = executeResult
        self.refreshResult = refreshResult
    }

    func execute() async throws -> [Product] {
        try executeResult.get()
    }

    func refresh() async throws -> [Product] {
        try refreshResult.get()
    }
}

private func makeProduct(id: Int, title: String) -> Product {
    Product(
        id: id,
        title: title,
        description: "Descripción de prueba",
        category: "demo",
        price: 10,
        discountPercentage: 0,
        rating: 4.5,
        stock: 10,
        tags: [],
        brand: "Marca",
        sku: "SKU-\(id)",
        weight: 1,
        dimensions: Dimensions(width: 1, height: 1, depth: 1),
        warrantyInformation: "1 año",
        shippingInformation: "Envío en 3 días",
        availabilityStatus: "In Stock",
        reviews: [],
        returnPolicy: "30 días",
        minimumOrderQuantity: 1,
        meta: Meta(createdAt: .now, updatedAt: .now, barcode: "123", qrCode: "qr"),
        images: [],
        thumbnail: ""
    )
}
