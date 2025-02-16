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
    
    var body: some View {
        NavigationSplitView {
            SideBarView(selection: $selection, searchedItem: $searchedItem)
            //                .onChange(of: selection) { _,_ in
            //                    searchText = ""
            //                }
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
//#if os(macOS)
//            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
//#endif
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
