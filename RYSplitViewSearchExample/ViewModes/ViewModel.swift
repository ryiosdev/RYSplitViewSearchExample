//
//  ViewModel.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 2/16/25.
//

import Foundation
import Observation
import SwiftData

@Observable @MainActor
class ViewModel {
    // saved items in swiftData
    var items = [Item]() // rename to savedItems

    // results from searching by name with searchText
    var searchItemsByName: [Item] {
        searchItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    //the list of searchables..
    private var searchItems: [Item] {
        get {
            let names = ["Apple",
                         "Banana",
                         "Orange",
                         "Mango",
                         "Grape",
                         "Watermelon",
                         "Pineapple",
                         "Strawberry",
                         "Blueberry",
                         "Raspberry",
                         "Avocado",
                         "Lemon",
                         "Lime",
                         "Cherry",
                         "Kiwi",
                         "Coconut",
                         "Peach",
                         "Pear",
                         "Papaya",
                         "Plum",
                         "Apricot"]
            
            return names.sorted().map { Item(name: $0) }
        }
    }
    
    var selectedItem: Item?
    var searchedItem: Item?

    var searchText: String = ""
    var isSearchPresented: Bool = false
    var isDetailSheetPresented: Bool = false
    
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
    }
    
    private func fetchData() {
        do {
            let descriptor = FetchDescriptor<Item>(sortBy: [SortDescriptor(\.name)])
            items = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    func add(item: Item) {
        modelContext.insert(item)
        fetchData()
    }
    
    func delete(item: Item) {
        modelContext.delete(item)
        fetchData()
    }
            
    func onSubmit() {
        
    }
}
