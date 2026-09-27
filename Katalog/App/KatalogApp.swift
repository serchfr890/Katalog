//
//  KatalogApp.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import SwiftUI

@main
struct KatalogApp: App {
    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            ProductListView(
                viewModel: container.makeProductListViewModel(),
                favoritesStore: container.favoritesStore
            )
            .offlineBanner(isConnected: container.networkMonitor.isConnected)
            .task {
                await container.favoritesStore.load()
            }
        }
    }
}
