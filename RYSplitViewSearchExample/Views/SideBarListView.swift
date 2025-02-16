//
//  SideBarListView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct SideBarListView: View {
    @Binding var selection: Item?
    @Binding var searchedItem: Item?
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var isDetailSheetPresented = false

    var body: some View {
        VStack {
            List(items, id: \.name, selection: $selection) { item in
                // HACK .onDelete (swipe to delete) seems to only works on ForEach
                ForEach([item]) { item in
                    NavigationLink(item.name, value: item)
                }
                // Swipe to delete
                .onDelete(perform: deleteItems)
                // macOS right click delete
#if os(macOS)
                .contextMenu {
                    if let item = selection {
                        Button("Delete") {
                            withAnimation {
                                modelContext.delete(item)
                                selection = nil
                            }
                        }
                    }
                }
#endif
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
        }
        .onChange(of: searchedItem, initial: true) { (oldValue, newValue) in
            if newValue != nil  {
#if !os(macOS)
                isDetailSheetPresented = true
#endif
            } else {
                isDetailSheetPresented = false
            }
        }
        //iOS,iPadOS
        .sheet(isPresented: $isDetailSheetPresented) {
            SheetDetailView(isPresented: $isDetailSheetPresented,
                            selection: $selection,
                            searchedItem: searchedItem)
            .onDisappear {
                searchedItem = nil
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
                if selection == items[index] {
                    selection = nil
                }
            }
        }
    }
}
