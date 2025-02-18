//
//  Item.swift
//  test
//
//  Created by Ryan Young on 2/14/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var name: String
    var createdAt: Date
    
    init(_ name: String, createdAt: Date = Date()) {
        self.name = name
        self.createdAt = createdAt
    }
}
