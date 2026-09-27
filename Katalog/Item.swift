//
//  Item.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
