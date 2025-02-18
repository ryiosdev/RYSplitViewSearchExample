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

    // An 'Item' from `savedItems` array that is selected and displayed in the details view, if `searchedItem` is not set.
    var selectedItem: Item?
    
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
            return names.sorted().map { Item($0) }
        }
    }
    
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchSavedItems()
        searchableItems = initialSearchableItems
        
#if os(iOS)
        if let first = savedItems.first {
            selectedItem = first
        }
#endif
    }
    
    private func fetchSavedItems() {
        do {
            let descriptor = FetchDescriptor<Item>(sortBy: [SortDescriptor(\.name)])
            savedItems = try modelContext.fetch(descriptor).sorted{ $0.createdAt < $1.createdAt }
        } catch {
            print("Fetch failed")
        }
    }
    
    func add(item: Item) {
        modelContext.insert(item)
        try? modelContext.save()
        fetchSavedItems()
    }
    
    func delete(_ item: Item) {
        if let index = savedItems.firstIndex(of: item) {
            modelContext.delete(item)
            try? modelContext.save()
            fetchSavedItems()
            
#if os(macOS)

            //if there still is an item at this index, select it
            if savedItems.indices.contains(index) {
                selectedItem = savedItems[index]
            // if not, and there is at least one item, select the first
            } else if let first = savedItems.first {
                selectedItem = first
            // nothing is selectable
            } else {
                selectedItem = nil
            }
#endif
        }
    }
            
    func onSubmitOfSearch() {
        //on submit (enter key), show the first searched suggestion, if it exist
        let items = searchedItemsByName
        print("submitted search text '\(searchText)' returned : \(items.map(\.name))")
        showSearchResult(items.first)
    }
    
    private func showSearchResult(_ item: Item?) {
        guard let item else { return }
        searchText = item.name // "auto-complete" search text
        isSearchPresented = false
        searchedItem = item
#if os(macOS)
        //deselect the macOS side bar if the searched item is ont already a saved item.
        selectedItem = isSearchedItemAlreadySaved() ? selectedItem : nil
#endif
    }
    
    private func isSearchedItemAlreadySaved() -> Bool {
        guard let searchedItem else { return false }
        return savedItems.contains { $0.name == searchedItem.name}
    }

}
