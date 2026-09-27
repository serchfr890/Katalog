//
//  AppContainer.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation

struct AppContainer {
    private let productRepository: ProductRepository = ProductRepositoryImpl()

    func makeProductListViewModel() -> ProductListViewModel {
        ProductListViewModel(
            fetchProductsUseCase: FetchProductsUseCaseImpl(repository: productRepository)
        )
    }
}
