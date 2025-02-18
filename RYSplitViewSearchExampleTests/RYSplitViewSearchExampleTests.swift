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
            //Given: The current datetime
            let date = Date()
            
            //When: initializing an Item
            let item = Item("Test", createdAt: date)
            
            //Then: The Item's properties should match what was passed into the `init` method.
            #expect(item.name == "Test")
            #expect(item.createdAt == date)
        }
        
        @Test func initPropertiesWithDefaultDate() {
            //Given: An item initialized without the `createdAt` date
            let item = Item("Test")
                        
            //Then: The `createdAt` date should be very close to `Date.now`. (depends on mili or micro seconds)
            #expect(item.createdAt < Date.now.addingTimeInterval(0.5))
            #expect(item.createdAt > Date.now.addingTimeInterval(-0.5))
        }
    }
}


struct ViewModelTests {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)

    @MainActor
    @Test func initProperties() throws {
        let container = try ModelContainer(for: Item.self, configurations: config)
        let viewModel = ViewModel(modelContext: container.mainContext)

        #expect(viewModel.savedItems.count == 0)
    }
    
    @MainActor
    @Test func addedItemIsSaved() throws {
        let container = try ModelContainer(for: Item.self, configurations: config)
        let viewModel = ViewModel(modelContext: container.mainContext)
        
        viewModel.add(item: Item("Test"))
        
        #expect(viewModel.savedItems.count == 1)
        #expect(viewModel.savedItems[0].name == "Test")
    }
}

