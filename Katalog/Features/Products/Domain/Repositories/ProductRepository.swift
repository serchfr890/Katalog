//
//  ProductRepository.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation

protocol ProductRepository {
    func getProducts() async throws -> [Product]
    func refreshProducts() async throws -> [Product]
    func getProduct(id: Int) async throws -> Product
}
