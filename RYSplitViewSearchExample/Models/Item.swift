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
    var id: UUID
    var name: String
    var savedAt: Date?
    
    init(_ name: String) {
        self.id = UUID()
        self.name = name
    }
}
