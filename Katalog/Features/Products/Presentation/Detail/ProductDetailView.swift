//
//  ProductDetailView.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        Text(product.title)
            .navigationTitle("Detalle")
    }
}
