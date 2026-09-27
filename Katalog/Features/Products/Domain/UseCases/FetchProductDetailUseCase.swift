//
//  FetchProductDetailUseCase.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation

protocol FetchProductDetailUseCase {
    func execute(id: Int) async throws -> Product
}

final class FetchProductDetailUseCaseImpl: FetchProductDetailUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> Product {
        try await repository.getProduct(id: id)
    }
}
