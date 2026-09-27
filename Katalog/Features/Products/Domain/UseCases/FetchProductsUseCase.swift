//
//  FetchProductsUseCase.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation

protocol FetchProductsUseCase {
    func execute() async throws -> [Product]
}

final class FetchProductsUseCaseImpl: FetchProductsUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Product] {
        try await repository.getProducts()
    }
}
