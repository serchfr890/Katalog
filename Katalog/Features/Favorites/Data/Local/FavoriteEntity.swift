//
//  FavoriteEntity.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation
import SwiftData

@Model
final class FavoriteEntity {
    @Attribute(.unique) var productId: Int

    init(productId: Int) {
        self.productId = productId
    }
}
