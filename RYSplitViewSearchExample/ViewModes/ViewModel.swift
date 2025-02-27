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
    
    //TODO: this should be "view logic" not really viewModel logic.
    // State to indicate `searchedItem`'s detail view should be presented as a modal sheet
    var isSheetDetailPresented: Bool = false
    
    // Used for Search results and Auto-complete search results of `Items` for the current `searchText` value
    // Case-insensitive search if `searchText` text is contianed within the `name` property of `searchableItems`
    // also don't include previously saved items with 'savedAt' set
    var searchedItemsByName: [Item] {
        searchableItems.filter { searchItem in
            searchItem.name.lowercased().contains(searchText.lowercased())
        }
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
    
    private func fetchSavedItems() {
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
        item.savedAt = nil
        modelContext.delete(item)
        try? modelContext.save()
    }
    
    private func delete(ids: Set<Item.ID>) {
        for id in ids {
            if let item = savedItems.first(where: { $0.id == id }) {
                item.savedAt = nil
                modelContext.delete(item)
            }
        }
        try? modelContext.save()
    }
}

// MARK: SideBar Actions
extension ViewModel {
    func tappedSideBar(item: Item) {
        selectedItemIds = [item.id]
        searchedItem = nil
    }
    
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
    
    //TODO: roll back delete helper method/logic for selecting the next item after delete completes.
}

// MARK: Search and Detail Actions
extension ViewModel {
    func firstSelectedItem() -> Item? {
        guard let firstSelectedItemId = selectedItemIds.first else { return nil }
        let item = savedItems.first(where: { $0.id == firstSelectedItemId })
        print("first selected item : \(item?.name ?? "")")
        return item
    }

    func onSubmitOfSearch() {
        print("on submit of search with text : '\(searchText)'")
        // show the item details if the searchText is an exact match to one of the item's name
        if let item = searchableItems.first(where: { $0.name == searchText } ) {
            showDetails(for: item)
        } else {
            // check for partial matches
            let items = searchableItems.filter( { $0.name.lowercased().contains(searchText.lowercased()) } )
            
            // if partial match, auto complete to the first item in the list.
            if items.count > 0 {
                showDetails(for: items[0])
            } else {
                searchedItem = nil
            }
        }
#if os(iOS)
        if searchedItem != nil {
            isSheetDetailPresented = true
        }
#endif
    }
    
    private func showDetails(for item: Item) {
        print("Show Details for : '\(item.name)'")
        searchedItem = item
        selectedItemIds = []
    }
        
    func isSearchedItemAlreadySaved() -> Bool {
        guard let searchedItem else { return false }
        return savedItems.contains { $0.name == searchedItem.name}
    }
    
    func addToSavedItems(item: Item) {
        print("Add to saved : '\(item.name)'")
        item.savedAt = Date()
        add(item: item)
        fetchSavedItems()
        searchedItem = nil
#if os(iOS)
        searchText = ""
        selectedItemIds = []
#elseif os(macOS)
        selectedItemIds = [item.id]
#endif
    }
    
    func onDismissOfSheetDetailView() {
        searchedItem = nil
        selectedItemIds = []
    }
}
