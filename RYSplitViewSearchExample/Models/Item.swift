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
    
    init(name: String) {
        self.name = name
        self.createdAt = Date()
    }
}
