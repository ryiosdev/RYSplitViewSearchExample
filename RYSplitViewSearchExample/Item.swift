//
//  Item.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 2/15/25.
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
