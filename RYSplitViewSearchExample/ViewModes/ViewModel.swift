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
    
    // Indicates if `searchedItem` search result is being displayed in a modal Sheet (iOS only)
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
    
    private func fetchSavedItems() {
        do {
            let descriptor = FetchDescriptor<Item>(sortBy: [SortDescriptor(\.savedAt)])
            savedItems = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    func add(item: Item, _ completion: (() -> Void)? = nil) {
        
        modelContext.insert(item)
        try? modelContext.save()
        fetchSavedItems()
        completion?()
    }
    
    func delete(_ item: Item) {
        
        modelContext.delete(item) // TODO: copy method and pass in index set
        try? modelContext.save()
        fetchSavedItems()
        updateSelectedItemAfterDeleting(item)
    }
    
    func updateSelectedItemAfterDeleting(_ item: Item) {
#if os(macOS)
        let originalItemIndex = savedItems.firstIndex(of: item)
        
        if let index = originalItemIndex {
            //for macOS, if there still is an item at this index, select it
            if savedItems.indices.contains(index) {
                selectedItemIds = [savedItems[index].id]
            // if not, and there is at least one item, select the first
            } else if let first = savedItems.first {
                selectedItemIds = [first.id]
            // nothing is selectable
            } else {
                selectedItemIds = []
            }
        }
#endif
    }
     
    func searchCompletionString(for item: Item) -> String {
        searchText
    }
    
    func searchSuggestionTapped(for item: Item) {
        searchedItem = item
        isDetailSheetPresented = true
    }
    
    func onSubmitOfSearch() {
        //on submit (enter key), show the first searched suggestion, if it exist
#if os(macOS)
        let items = searchedItemsByName
        print("submitted search text '\(searchText)' returned : \(items.map(\.name))")
        showSearchResult(for: items.first)
#endif
    }
    
    private func showSearchResult(for item: Item?) {
        guard let item else { return }
        searchText = item.name // "auto-complete" search text
        isSearchPresented = false
        searchedItem = item
    }
    
    func isSearchedItemAlreadySaved() -> Bool {
        guard let searchedItem else { return false }
        return savedItems.contains { $0.name == searchedItem.name}
    }
}
