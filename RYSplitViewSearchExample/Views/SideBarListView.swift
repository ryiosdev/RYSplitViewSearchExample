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
        List(selection: $viewModel.selectedItem) {
            ForEach(viewModel.savedItems) { item in
                NavigationLink {
                    ItemDetailView(item: item)
                } label: {
                    ItemRowView(item: item)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                withAnimation {
                                    viewModel.deleteSideBar(item: item)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .navigationTitle("SplitView Search")
#if os(macOS)
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
