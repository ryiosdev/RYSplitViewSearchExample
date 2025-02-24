//
//  Item.swift
//  test
//
//  Created by Ryan Young on 2/14/25.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var name: String
    var savedAt: Date?
    
    init(_ name: String, savedAt: Date? = nil) {
        self.name = name
        self.savedAt = savedAt
    }
}
