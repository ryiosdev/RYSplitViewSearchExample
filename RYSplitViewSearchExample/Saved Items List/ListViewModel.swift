//
//  ListViewModel.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 3/15/25.
//

import Foundation
import Observation
import SwiftData
import SwiftUI

enum ListViewState {
    case loading
    case loaded([Item])
    case error(String)
}

@Observable @MainActor
class ListViewModel {
    var listViewState: ListViewState = .loaded([])
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        refreshItemsList()
    }
    
    func refreshItemsList() {
        listViewState = .loading
        do {
            let descriptor = FetchDescriptor<Item>(predicate: #Predicate { $0.savedAt != nil },
                                                   sortBy: [SortDescriptor(\.savedAt)])
            let items = try modelContext.fetch(descriptor)
            listViewState = .loaded(items)
        } catch {
            listViewState = .error(error.localizedDescription)
        }
    }
    
    func delete(item: Item) {
        modelContext.delete(item)
        try? modelContext.save()
        refreshItemsList()
    }
}
