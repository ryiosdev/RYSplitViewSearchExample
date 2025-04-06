//
//  ItemDetailViewModel.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 3/31/25.
//

import Foundation
import Observation
import SwiftData

@Observable @MainActor
class ItemDetailViewModel {
    enum ItemDetailState {
        case noItem
        case saved(Item)
        case unsaved(Item)
        case error(String)
    }
    var itemDetailState : ItemDetailState

    @ObservationIgnored private var modelContext: ModelContext

    init(item: Item?, modelContext: ModelContext) {
        self.modelContext = modelContext
        
        guard let item = item else {
            self.itemDetailState = .noItem
            return
        }
        
        let descriptor = FetchDescriptor<Item>(predicate: #Predicate { $0.id == item.id && $0.savedAt != nil })
        do {
            if let foundItem = try self.modelContext.fetch(descriptor).first {
                self.itemDetailState = .saved(foundItem)
            } else {
                self.itemDetailState = .unsaved(item)
            }
        } catch {
            self.itemDetailState = .error(error.localizedDescription)
        }
    }
    
    func save() {
        if case let .unsaved(item) = itemDetailState {
            item.savedAt = Date()
            modelContext.insert(item)
            do {
                try modelContext.save()
                itemDetailState = .saved(item)
            } catch {
                item.savedAt = nil
                itemDetailState = .error(error.localizedDescription)
            }
        }
    }
    
    func delete() {
        if case let .saved(item) = itemDetailState {
            modelContext.delete(item)
            do {
                try modelContext.save()
                item.savedAt = nil
                itemDetailState = .unsaved(item)
            } catch {
                itemDetailState = .error(error.localizedDescription)
            }
        }
    }
}
