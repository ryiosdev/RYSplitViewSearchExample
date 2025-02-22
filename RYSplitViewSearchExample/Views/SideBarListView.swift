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
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        List(selection: $viewModel.selectedItemIds) {
            ForEach(itemsToShow()) { item in
                ItemRowView(item: item)
                    .onTapGesture {
                        print("tapped on \(item.name)")
                        viewModel.selectedItemIds = [item.id]
                        viewModel.searchedItem = nil
                    }
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
        }
        .navigationTitle("SplitView Search")
#if os(iOS)
        .sheet(isPresented: $viewModel.isSheetDetailPresented,
               onDismiss: {
            withAnimation {
                viewModel.onDismissOfSheetDetailView()
            }
        }, content: {
            SheetDetailView(viewModel: viewModel)
        })
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
    
    private func itemsToShow() -> [Item] {
#if os(iOS)
        guard viewModel.isSearchPresented == false else { return [] }
#endif
        return viewModel.savedItems
    }
}
