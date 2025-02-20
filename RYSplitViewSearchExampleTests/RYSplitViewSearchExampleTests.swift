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
        @Test func initProperties() {
            //Given: an initialized Item
            let item = Item("Test")

            
            //When: the `savedAt` date is set
            let date = Date()
            item.savedAt = date
            
            //Then: The Item's correct properties should have changed.
            #expect(item.name == "Test")
            #expect(item.savedAt == date)
        }
        
        @Test func initPropertiesWithDefaultDate() {
            //Given: An item initialized without the `savedAt` date
            let item = Item("Test")
                        
            //Then: The `savedAt` date should nil
            #expect(item.savedAt == nil)
        }
    }
}


@MainActor
struct ViewModelTests {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)

    
    @Test func initProperties() throws {
        let container = try ModelContainer(for: Item.self, configurations: config)
        let viewModel = ViewModel(modelContext: container.mainContext)

        #expect(viewModel.savedItems.count == 0)
    }
    
    @Test func addedItemIsSaved() throws {
        let container = try ModelContainer(for: Item.self, configurations: config)
        let viewModel = ViewModel(modelContext: container.mainContext)
        
        viewModel.addSheetDetail(item: Item("Test"))
        
        #expect(viewModel.savedItems.count == 1)
        #expect(viewModel.savedItems[0].name == "Test")
    }
}

