//
//  ProductsResponse.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation

struct ProductsResponse: Decodable {
    let products: [Product]
}
