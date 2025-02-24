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
    // Saved items in SwiftData
    private(set) var savedItems = [Item]()
    
    // 'Item.ID's from `savedItems` array that are selected, the first item is displayed in the details view, if `searchedItem` is not set.
    var selectedItem: Item?
    
    // The current search text entered by the user.
    var searchText: String = ""
    
    private let majorCities = ["New York City", "Los Angeles", "Chicago", "Houston", "Phoenix",
                       "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose",
                       "Austin", "Jacksonville", "Fort Worth", "Columbus", "Charlotte",
                       "Indianapolis", "San Francisco", "Seattle", "Denver", "Washington D.C."]
    
    private let searchedCitiesToItem = [String:Item]()
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchSavedItems()
#if os(iOS)
        if let first = savedItems.first {
            selectedItem = first
        }
#endif
    }
    
    func fetchSavedItems() {
        do {
            let descriptor = FetchDescriptor<Item>(sortBy: [SortDescriptor(\.savedAt)])
            savedItems = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed to get saved items")
        }
    }
    
    private func add(item: Item) {
        modelContext.insert(item)
        try? modelContext.save()
    }
    
    private func delete(item: Item) {
        modelContext.delete(item)
        try? modelContext.save()
    }
    
    private func delete(ids: Set<Item.ID>) {
        try? modelContext.delete(model: Item.self, where: #Predicate {item in ids.contains(item.id)})
        try? modelContext.save()
    }
}

// MARK: SideBar Actions
extension ViewModel {    
    func deleteSideBar(item: Item) {
        delete(item: item)
        fetchSavedItems()
    }
    
    func shouldShowDeleteButton(for ids: Set<Item.ID>) -> Bool {
        ids.count > 0
    }
    
    func deleteSideBarItems(ids: Set<Item.ID>) {
        delete(ids: ids)
        fetchSavedItems()
    }
    
    func firstSelectedItem() -> Item? {
        guard let selectedItem else { return nil }
        let item = savedItems.first(where: { $0.id == selectedItem.id })
        print("first selected item : `\(item?.name ?? "")`")
        return item
    }

    //TODO: roll back delete helper method/logic for selecting the next item after delete completes.
}

// MARK: Search and Detail Actions
extension ViewModel {
    func suggestionsForCurrentSearch() -> [String] {
        majorCities.filter { city in
            city.lowercased().contains(searchText.lowercased())
        }
    }
    
    func onSubmitOfSearch() {
        guard !searchText.isEmpty else { return }
        print("on submit of search with text : '\(searchText)'")
        
        // Check for exact match
        if let city = majorCities.first(where: { $0 == searchText } ) {
            print("-> exact match: \(city)")
            selectedItem = itemExists(for: city) ?? Item(city)
        } else {
            selectedItem = savedItems.first
        }
    }
    
//    private func showDetails(for city: String?) {
//        print("Show Details for : '\(city ?? "")'")
//        if let city = city {
//            
//            itemForDetailView = Item(city)
//            selectedItemIds = []
//            searchText = ""
//            
//        } else {
//            itemForDetailView = nil
//        }
//        
//    }
    
    private func itemExists(for name: String) -> Item? {
        if let existingItem = savedItems.first(where: { $0.name == name }) {
            print("->     existing item: \(name) found, use it instead")
            return existingItem
        }
        return nil
    }
    
    func saveDetailItem() {
        guard let selectedItem else { return }
        selectedItem.savedAt = Date()
        add(item: selectedItem)
        fetchSavedItems()
    }
}
