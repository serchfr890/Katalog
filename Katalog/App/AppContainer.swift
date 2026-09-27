//
//  AppContainer.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation
import SwiftData

struct AppContainer {
    private let modelContainer: ModelContainer
    private let productRepository: ProductRepository

    init() {
        do {
            modelContainer = try ModelContainer(for: ProductEntity.self)
        } catch {
            fatalError("No se pudo inicializar el ModelContainer: \(error)")
        }
        let localDataSource = ProductLocalDataSourceImpl(modelContainer: modelContainer)
        productRepository = ProductRepositoryImpl(localDataSource: localDataSource)
    }

    func makeProductListViewModel() -> ProductListViewModel {
        ProductListViewModel(
            fetchProductsUseCase: FetchProductsUseCaseImpl(repository: productRepository)
        )
    }
}
