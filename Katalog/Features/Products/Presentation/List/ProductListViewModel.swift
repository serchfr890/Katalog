//
//  ProductListViewModel.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation

@MainActor
@Observable
final class ProductListViewModel {
    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let fetchProductsUseCase: FetchProductsUseCase

    init(fetchProductsUseCase: FetchProductsUseCase) {
        self.fetchProductsUseCase = fetchProductsUseCase
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            products = try await fetchProductsUseCase.execute()
        } catch {
            errorMessage = "No se pudieron cargar los productos."
        }
        isLoading = false
    }
}
