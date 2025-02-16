//
//  SheetDetailview.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct SheetDetailView: View {
    @Binding var isPresented: Bool
    @Binding var selection: Item?
    var searchedItem: Item?
    
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            VStack {
                Text("Sheet search result item:")
                Text(searchedItem?.name ?? "")
            }
            .navigationTitle(searchedItem?.name ?? "")
            .toolbar {
                if let searched = searchedItem {
                    if !items.contains(where: { $0.name.lowercased() == searched.name.lowercased() } ) {
                        Button("Save") {
                            withAnimation {
                                modelContext.insert(searched)
                                dismissSearch()
                                selection = searched
                                isPresented = false
                            }
                        }
                    } else {
                        Button("Show") {
                            withAnimation {
                                dismissSearch()
                                selection = searched
                                isPresented = false
                            }
                        }
                    }
                }
            }
        }
    }
}
