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
    let networkMonitor: NetworkMonitor
    let favoritesStore: FavoritesStore

    init() {
        do {
            modelContainer = try ModelContainer(for: ProductEntity.self, FavoriteEntity.self)
        } catch {
            fatalError("No se pudo inicializar el ModelContainer: \(error)")
        }
        let localDataSource = ProductLocalDataSourceImpl(modelContainer: modelContainer)
        productRepository = ProductRepositoryImpl(localDataSource: localDataSource)
        networkMonitor = NetworkMonitor()

        let favoritesLocalDataSource = FavoritesLocalDataSourceImpl(modelContainer: modelContainer)
        favoritesStore = FavoritesStore(repository: FavoritesRepositoryImpl(localDataSource: favoritesLocalDataSource))
    }

    func makeProductListViewModel() -> ProductListViewModel {
        ProductListViewModel(
            fetchProductsUseCase: FetchProductsUseCaseImpl(repository: productRepository)
        )
    }
}
