//
//  SideBarListView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct SideBarListView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var viewModel: ViewModel
    
    var body: some View {
        List(selection: $viewModel.selectedItemIds) {
            ForEach(viewModel.savedItems) { item in
                NavigationLink(item.name, value: item.id)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.delete(item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            // on iOS/iPadOS, Swipe to delete or Edit -> Delete buttons
            .onDelete { indexSet in
                withAnimation {
                    deleteItems(offsets: indexSet)
                }
            }
        }
#if os(iOS)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .sheet(isPresented: $viewModel.isDetailSheetPresented) {
            SheetDetailView(viewModel: $viewModel)
            .onDisappear {
                viewModel.searchedItem = nil
            }
        }
#elseif os(macOS)
        // macOS right click delete
        .contextMenu(forSelectionType: Item.ID.self) { ids in
            // if at least one side bar row selected
            if ids.count > 0 {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        // TODO: move to ViewModel
                        print("context menu delete : \(ids)")
                        let items = viewModel.savedItems.filter({ ids.contains($0.id) })
                        items.forEach { item in
                            viewModel.delete(item)
                        }
                    }
                }
            }
        }
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // TODO: move to viewModel
            for index in offsets {
                let item = viewModel.savedItems[index]
                viewModel.delete(item)
            }
        }
    }
}
