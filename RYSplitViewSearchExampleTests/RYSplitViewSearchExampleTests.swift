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

    @Test func initProperties() throws {
        // Given: a new `ViewModel` with an empty
        let container = try ModelContainer(for: Item.self, configurations: config)
        let viewModel = ViewModel(modelContext: container.mainContext)

        // Then: the default values should be as expected
        #expect(viewModel.savedItems.isEmpty)
        #expect(viewModel.selectedItemIds.isEmpty)
        #expect(viewModel.searchedItem == nil)
        #expect(viewModel.searchText == "")
        #expect(viewModel.isSearchPresented == false)
    }
    
    @Test func addedItemIsSaved() throws {
        // Given a new empty
        let container = try ModelContainer(for: Item.self, configurations: config)
        let viewModel = ViewModel(modelContext: container.mainContext)
        
        viewModel.addToSavedItems(item: Item("Test"))
        
        #expect(viewModel.savedItems.count == 1)
        #expect(viewModel.savedItems[0].name == "Test")
        #expect(viewModel.savedItems[0].savedAt != nil)
        #expect(viewModel.isSearchPresented == false)
    }
}

