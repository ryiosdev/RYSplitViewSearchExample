//
//  Item.swift
//  test
//
//  Created by Ryan Young on 2/14/25.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case id
        case name
        case savedAt
    }
    
    var id: UUID
    var name: String
    var savedAt: Date? = nil
    
    init(_ name: String) {
        self.id = UUID()
        self.name = name
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        savedAt = try container.decodeIfPresent(Date.self, forKey: .savedAt)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(savedAt, forKey: .savedAt)
    }
}

extension Item {
    static func itemsFrom(data: Data) throws -> [Item] {
        let model = try JSONDecoder().decode([Item].self, from: data)
        return model
    }
}

