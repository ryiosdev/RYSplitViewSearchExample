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
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        List(selection: $viewModel.selectedItemIds) {
            ForEach(viewModel.savedItems) { item in
                NavigationLink(item.name, value: item.id)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.deleteSideBarItem(item)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            // on iOS/iPadOS, Swipe to delete or Edit -> Delete buttons
            .onDelete { offsets in
                withAnimation {
                    viewModel.deleteSideBarItems(at: offsets)
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
            SheetDetailView(viewModel: viewModel)
            .onDisappear {
                viewModel.searchedItem = nil
            }
        }
#elseif os(macOS)
        // macOS right click delete
        .contextMenu(forSelectionType: Item.ID.self) { ids in
            // if at least one side bar row selected
            if viewModel.shouldShowDeleteButton(for: ids) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        viewModel.deleteSideBarItems(ids: ids)
                    }
                }
            }
        }
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
    }
}
