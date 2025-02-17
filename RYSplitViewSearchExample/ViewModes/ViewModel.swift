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
    var savedItems = [Item]()

    // results from searching by name with searchText
    var searchedItemsByName: [Item] {
        searchableItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    //the list of searchables..
    private var searchableItems: [Item] {
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
        fetchSavedData()
    }
    
    private func fetchSavedData() {
        do {
            let descriptor = FetchDescriptor<Item>(sortBy: [SortDescriptor(\.name)])
            savedItems = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    func add(item: Item) {
        modelContext.insert(item)
        fetchSavedData()
    }
    
    func delete(item: Item) {
        modelContext.delete(item)
        fetchSavedData()
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
