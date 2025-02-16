//
//  ContentView.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var selection: Item?
    
    @State private var searchText: String = ""
    @State private var isSearchPresented = false
    var searchItems = [Item(name: "Apple"),
                       Item(name: "Banana"),
                       Item(name: "Orange"),
                       Item(name: "Mango"),
                       Item(name: "Grape"),
                       Item(name: "Watermelon"),
                       Item(name: "Pineapple"),
                       Item(name: "Strawberry"),
                       Item(name: "Blueberry"),
                       Item(name: "Raspberry"),
                       Item(name: "Avocado"),
                       Item(name: "Lemon"),
                       Item(name: "Lime"),
                       Item(name: "Cherry"),
                       Item(name: "Kiwi"),
                       Item(name: "Coconut"),
                       Item(name: "Peach"),
                       Item(name: "Pear"),
                       Item(name: "Papaya"),
                       Item(name: "Plum")]
    @State private var searchedItem: Item?

    var body: some View {
        
        
        NavigationSplitView {
            SideBarListView(selection: $selection, searchedItem: $searchedItem)
        } detail: {
            DetailView(selection: $selection, searchedItem: $searchedItem)
        }
        .searchable(text: $searchText, isPresented: $isSearchPresented, prompt: "Add")
        .searchSuggestions {
            SearchSuggestionsView(searchText: $searchText, searchItems: searchItems)
        }
        .onSubmit(of: .search) {
            print("submitted search text : \(searchText)")
            if let item = searchItems.first(where: { $0.name.lowercased().contains(searchText.lowercased()) } ) {
                searchedItem = item
                
#if os(macOS)
                //deselect the macOS side bar is
                selection = nil
#endif
            }
        }
    }
}
        
        
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }

//            .toolbar {
//#if os(iOS)
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//#endif
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
