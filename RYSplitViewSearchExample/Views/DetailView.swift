//
//  DetailView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Binding var selection: Item?
    @Binding var searchedItem: Item?
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        if let searched = searchedItem {
            VStack {
#if os(macOS)
                Text("Search result item:")
                Text(searched.name)
                //if not already saved, show the Save button
                if !items.contains(where: { $0.name.lowercased() == searched.name.lowercased() } ) {
                    Button("Save") {
                        withAnimation {
                            modelContext.insert(searched)
                            selection = searched
                            searchedItem = nil
                        }
                    }
                }
#endif
            }
        } else if let selectedItem = selection {
            VStack {
                Text("Selected item:")
                Text(selectedItem.name)
            }
            .navigationTitle(selectedItem.name)
        } else {
            Text("Select or Search for an item")
            
        }
    }
}
