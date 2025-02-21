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
    var selectedItemIds = Set<Item.ID>()
    
    // The result of the user's`searchText` query
    var searchedItem: Item?
    
    // The current search text entered by the user.
    var searchText: String = ""
    
    // if the search bar is selected/activated.
    var isSearchPresented: Bool = false
    
    // State to indicate `searchedItem`'s detail view should be presented as a modal sheet
    var isDetailSheetPresented: Bool = false
    
    // Used for Search results and Auto-complete search results of `Items` for the current `searchText` value
    // Case-insensitive search if `searchText` text is contianed within the `name` property of `searchableItems`
    var searchedItemsByName: [Item] {
        searchableItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    // The internal list of searchable Items
    private var searchableItems = [Item]()
    
    // initial values to use for `searchableItems`
    private var initialSearchableItems: [Item] {
        get {
            let majorCities = [
                "New York City", "Los Angeles", "Chicago", "Houston", "Phoenix",
                "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose",
                "Austin", "Jacksonville", "Fort Worth", "Columbus", "Charlotte",
                "Indianapolis", "San Francisco", "Seattle", "Denver", "Washington D.C."
            ]
            return majorCities.sorted().map { Item($0) }
        }
    }
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchSavedItems()
        searchableItems = initialSearchableItems
        
#if os(iOS)
        if let first = savedItems.first {
            selectedItemIds = [first.id]
        }
#endif
    }
    
    func fetchSavedItems() {
        do {
            let descriptor = FetchDescriptor<Item>(sortBy: [SortDescriptor(\.savedAt)])
            savedItems = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
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
    
    private func delete(offsets: IndexSet) {
        let offsetIds = offsets.map { savedItems[$0].id }
        try? modelContext.delete(model: Item.self, where: #Predicate {item in offsetIds.contains(item.id)})
        try? modelContext.save()
    }
    
    private func delete(ids: Set<Item.ID>) {
        try? modelContext.delete(model: Item.self, where: #Predicate {item in ids.contains(item.id)})
        try? modelContext.save()
    }
}

// MARK: SideBar Actions
extension ViewModel {
    func deleteSideBarItem(_ item: Item) {
        delete(item: item)
        fetchSavedItems()
    }
    
    func deleteSideBarItems(at offsets: IndexSet) {
        delete(offsets: offsets)
        fetchSavedItems()
    }
    
    func shouldShowDeleteButton(for ids: Set<Item.ID>) -> Bool {
        ids.count > 0
    }
    
    func deleteSideBarItems(ids: Set<Item.ID>) {
        delete(ids: ids)
        fetchSavedItems()
    }
}

// MARK: Search and Detail Actions
extension ViewModel {
    func firstSelectedItem() -> Item? {
        //TODO: gaurd if savedItem currently displayed..
        guard let firstSelectedItemId = selectedItemIds.first else { return nil }
        let item = savedItems.first(where: { $0.id == firstSelectedItemId })
        print("first selected item : \(item?.name ?? "")")
        return item
    }

    func searchCompletionString(for item: Item) -> String {
        item.name
    }
    
    func onSubmitOfSearch() {
        print("on submit of search with text : '\(searchText)'")
        if let item = searchableItems.first(where: { $0.name == searchText } ) {
            selectedItemIds = []
            searchedItem = item
#if os(iOS)
            isDetailSheetPresented = true
#endif
        }
    }
        
    func isSearchedItemAlreadySaved() -> Bool {
        guard let searchedItem else { return false }
        return savedItems.contains { $0.name == searchedItem.name}
    }
    
    func addToSavedItems(item: Item) {
        item.savedAt = Date()
        add(item: item)
        fetchSavedItems()
        isSearchPresented = false
#if os(iOS)
        searchText = ""
#endif
    }
}
