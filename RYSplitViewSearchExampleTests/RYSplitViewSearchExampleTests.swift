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

//@MainActor
//struct ViewModelTests {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    
//    @Test func initDefaultProperties() throws {
//        // Given: a new `ViewModel` with an empty context
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        
//        // When: init `ViewModel`
//        let viewModel = ViewModel(modelContext: container.mainContext)
//        
//        // Then: the default values should be as expected
//        #expect(viewModel.savedItems.isEmpty)
//        #expect(viewModel.selectedItemIds.isEmpty)
//        #expect(viewModel.searchedItem == nil)
//        #expect(viewModel.searchText == "")
//    }
//    
//    @Test func initWithSingleItemUpdatesCorrectProperties() throws {
//        // Given: a new `ViewModel` with a context containing a single item
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        let context = container.mainContext
//        let item = Item("Test")
//        item.savedAt = Date()
//        context.insert(item)
//        try context.save()
//        
//        // When: init `ViewModel`
//        let viewModel = ViewModel(modelContext: container.mainContext)
//        
//        // Then: the `ViewModel` properties should reflect the context's data
//        #expect(viewModel.savedItems.count == 1)
//        #expect(viewModel.savedItems[0].name == "Test")
//        #expect(viewModel.savedItems[0].savedAt != nil)
//#if os(iOS)
//        #expect(viewModel.selectedItemIds.count == 1)
//#endif
//    }
//    
//    @Test func initWithMultipleItemsUpdatesCorrectProperties() throws {
//        // Given: a new `ViewModel` with a context containing a multiple item
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        let context = container.mainContext
//        let item1 = Item("Test1")
//        let item2 = Item("Test2")
//        item1.savedAt = Date()
//        item2.savedAt = Date().addingTimeInterval(5)
//        context.insert(item1)
//        context.insert(item2)
//        try context.save()
//        
//        // When: init `ViewModel`
//        let viewModel = ViewModel(modelContext: container.mainContext)
//        
//        // Then: the `ViewModel` properties should reflect the context's data with items in proper `saveAt` order
//        #expect(viewModel.savedItems.count == 2)
//        #expect(viewModel.savedItems[0].name == "Test1")
//        #expect(viewModel.savedItems[0].savedAt != nil)
//        #expect(viewModel.savedItems[1].name == "Test2")
//        #expect(viewModel.savedItems[1].savedAt != nil)
//#if os(iOS)
//        #expect(viewModel.selectedItemIds.count == 1)
//        #expect(viewModel.selectedItemIds.first == item1.id)
//#endif
//    }
//    
//    // SideBar Tests
//    @Test func tappedSideBarItem() throws {
//        // Given: a new `ViewModel` with a context containing a single item
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        let context = container.mainContext
//        let item = Item("Test")
//        item.savedAt = Date()
//        context.insert(item)
//        try context.save()
//        let viewModel = ViewModel(modelContext: container.mainContext)
//
//        //When: item is tapped
//        viewModel.tappedSideBar(item: item)
//        
//        //Then: selectedItemIds should contain the item that was tapped and the searchedItem set to nil
//        #expect(viewModel.selectedItemIds.contains(item.id))
//        #expect(viewModel.searchedItem == nil)
//    }
//    
//    @Test func deleteSideBarItem() throws {
//        // Given: a new `ViewModel` with a context containing a single item
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        let context = container.mainContext
//        let item = Item("Test")
//        item.savedAt = Date()
//        context.insert(item)
//        try context.save()
//        let viewModel = ViewModel(modelContext: container.mainContext)
//        
//        // When: deleting the item
//        viewModel.deleteSideBar(item: item)
//        
//        // Then: the list of savedItems should not contain the item, and the item's savedAt date is removed.
//        #expect(viewModel.savedItems.contains(item) == false)
//        #expect(item.savedAt == nil)
//    }
//    
//    @Test func shouldSideBarContextMenuShowDeleteButtonNoItems() throws {
//        // Given: an empty set of Ids (right clicking on empty space)
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        let viewModel = ViewModel(modelContext: container.mainContext)
//        let ids: Set<UUID> = []
//        
//        
//        // When: checking if right click delete button is available (macOS)
//        let shouldShow = viewModel.shouldShowDeleteButton(for: ids)
//        
//        // Then: the context menu should not be shown
//        #expect(shouldShow == false)
//    }
//    
//    @Test func deleteMultipleSelectedSideBarItems() throws {
//        // Given: multiple saved items selected in the side bar
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        let context = container.mainContext
//        let item1 = Item("Test1")
//        let item2 = Item("Test2")
//        let item3 = Item("Test3")
//        item1.savedAt = Date()
//        item2.savedAt = Date().addingTimeInterval(5)
//        item3.savedAt = Date().addingTimeInterval(10)
//        context.insert(item1)
//        context.insert(item2)
//        context.insert(item3)
//        try context.save()
//        let viewModel = ViewModel(modelContext: container.mainContext)
//        let ids: Set<UUID> = [item1.id, item2.id]
//        
//        // When: deleting the selected items
//        viewModel.deleteSideBarItems(ids: ids)
//        
//        // Then: all the selected items should be removed and other remain
//        #expect(viewModel.savedItems.map( {$0.id } ).contains(ids) == false)
//        #expect(item1.savedAt == nil)
//        #expect(item2.savedAt == nil)
//        #expect(viewModel.savedItems.first?.id == item3.id)
//        #expect(item3.savedAt != nil)
//    }
//    
//    // Search and Detail Tests
//    @Test func firstSelectedItemNotNilIfSelected() throws  {
//        // Given: a new `ViewModel` with a context containing a single item
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        let context = container.mainContext
//        let item = Item("Test")
//        item.savedAt = Date()
//        context.insert(item)
//        try context.save()
//        let viewModel = ViewModel(modelContext: container.mainContext)
//        viewModel.selectedItemIds = [item.id]
//        
//        // When: getting first selected item
//        let selected = viewModel.firstSelectedItem()
//        
//        // Then: the item should exists and match
//        #expect(selected == item)
//        #expect(viewModel.selectedItemIds.contains(selected!.id))
//    }
//    
//    @Test func onSubmitOfExactMatchSearch() throws {
//        // Given: search text exists
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        let viewModel = ViewModel(modelContext: container.mainContext)
//        viewModel.searchText = "San Antonio"
//        
//        // When: submitting the search string
//        viewModel.onSubmitOfSearch()
//        
//        // Then: the searchedItem should be set and have matching name to the search text
//        #expect(viewModel.searchedItem != nil)
//        #expect(viewModel.searchedItem!.name == viewModel.searchText)
//        #expect(viewModel.selectedItemIds.isEmpty)
//        
//#if os(iOS)
//        #expect(viewModel.isSheetDetailPresented)
//#endif
//    }
//    
//    @Test func onSubmitOfPartialMatchSearch() throws {
//        // Given: search text exists
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        let viewModel = ViewModel(modelContext: container.mainContext)
//        viewModel.searchText = "San A"
//        
//        // When: submitting the search string
//        viewModel.onSubmitOfSearch()
//        
//        // Then: the searchedItem should be set and have matching name to the search text
//        #expect(viewModel.searchedItem != nil)
//        #expect(viewModel.searchedItem!.name == "San Antonio")
//        #expect(viewModel.selectedItemIds.isEmpty)
//        
//#if os(iOS)
//        #expect(viewModel.isSheetDetailPresented)
//#endif
//    }
//    
//    @Test func addToSavedItemsUpdatesCorrectProperties() throws {
//        // Given: a new `ViewModel` with an empty context
//        let container = try ModelContainer(for: Item.self, configurations: config)
//        let viewModel = ViewModel(modelContext: container.mainContext)
//        
//        // When: addToSavedItems item into ViewModel
//        let item = Item("Test")
//        viewModel.addToSavedItems(item: item)
//        
//        // Then: the `ViewModel` properties should reflect the context's data
//        #expect(viewModel.savedItems.count == 1)
//        #expect(viewModel.savedItems[0].name == "Test")
//        #expect(viewModel.savedItems[0].savedAt != nil)
//#if os(iOS)
//        #expect(viewModel.selectedItemIds.count == 0)
//        #expect(viewModel.firstSelectedItem() == nil)
//#endif
//    }
//}
