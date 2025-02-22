//
//  RYSplitViewSearchExampleTests.swift
//  RYSplitViewSearchExampleTests
//
//  Created by Ryan Young on 2/15/25.
//

import Testing
import Foundation
import SwiftData

@testable import RYSplitViewSearchExample

struct ModelTests {
    struct ItemTests {
        @Test func defaultInit() {
            // Given: a new item
            let item = Item("Test")
            
            // Then: the `name` should be the as given in the `init()` and `savedAt` == nil
            #expect(item.name == "Test")
            #expect(item.savedAt == nil)
        }

        @Test func setItemSavedAtData() {
            // Given: an initialized Item
            let item = Item("Test")

            // When: the `savedAt` date is set
            let date = Date()
            item.savedAt = date
            
            // Then: the date should match what was set
            #expect(item.name == "Test")
            #expect(item.savedAt == date)
        }
    }
}

@MainActor
struct ViewModelTests {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)

    @Test func initDefaultProperties() throws {
        // Given: a new `ViewModel` with an empty context
        let container = try ModelContainer(for: Item.self, configurations: config)
        
        // When: init `ViewModel`
        let viewModel = ViewModel(modelContext: container.mainContext)

        // Then: the default values should be as expected
        #expect(viewModel.savedItems.isEmpty)
        #expect(viewModel.selectedItemIds.isEmpty)
        #expect(viewModel.searchedItem == nil)
        #expect(viewModel.searchText == "")
        #expect(viewModel.isSearchPresented == false)
    }
    
    @Test func initWithSingleItemUpdatesCorrectProperties() throws {
        // Given: a new `ViewModel` with a context containing a single item
        let container = try ModelContainer(for: Item.self, configurations: config)
        let context = container.mainContext
        let item = Item("Test")
        item.savedAt = Date()
        context.insert(item)
        try context.save()
        
        // When: init `ViewModel`
        let viewModel = ViewModel(modelContext: container.mainContext)
                
        // Then: the `ViewModel` properties should reflect the context's data
        #expect(viewModel.savedItems.count == 1)
        #expect(viewModel.savedItems[0].name == "Test")
        #expect(viewModel.savedItems[0].savedAt != nil)
#if os(iOS)
        #expect(viewModel.selectedItemIds.count == 1)
#endif
    }
    
    @Test func savingMultipleItemsUpdatesCorrectProperties() throws {
        // Given: a new `ViewModel` with a context containing a multiple item
        let container = try ModelContainer(for: Item.self, configurations: config)
        let context = container.mainContext
        let item1 = Item("Test1")
        let item2 = Item("Test2")
        item1.savedAt = Date()
        item2.savedAt = Date().addingTimeInterval(5)
        context.insert(item1)
        context.insert(item2)
        try context.save()
        
        // When: init `ViewModel`
        let viewModel = ViewModel(modelContext: container.mainContext)
                
        // Then: the `ViewModel` properties should reflect the context's data with items in proper `saveAt` order
        #expect(viewModel.savedItems.count == 2)
        #expect(viewModel.savedItems[0].name == "Test1")
        #expect(viewModel.savedItems[0].savedAt != nil)
        #expect(viewModel.savedItems[1].name == "Test2")
        #expect(viewModel.savedItems[1].savedAt != nil)
#if os(iOS)
        #expect(viewModel.selectedItemIds.count == 1)
        #expect(viewModel.selectedItemIds.first == item1.id)
#endif
    }
    
    @Test func addToSavedItemsUpdatesCorrectProperties() throws {
        // Given: a new `ViewModel` with an empty context
        let container = try ModelContainer(for: Item.self, configurations: config)
        let viewModel = ViewModel(modelContext: container.mainContext)
        
        // When: addToSavedItems item into ViewModel
        let item = Item("Test")
        viewModel.addToSavedItems(item: item)
        
        // Then: the `ViewModel` properties should reflect the context's data
        #expect(viewModel.savedItems.count == 1)
        #expect(viewModel.savedItems[0].name == "Test")
        #expect(viewModel.savedItems[0].savedAt != nil)
#if os(iOS)
        #expect(viewModel.selectedItemIds.count == 0)
        #expect(viewModel.firstSelectedItem() == nil)
#endif
    }
}
