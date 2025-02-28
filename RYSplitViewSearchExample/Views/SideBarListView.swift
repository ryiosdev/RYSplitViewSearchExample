//
//  SideBarListView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct SideBarListView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        List(selection: $viewModel.selectedItemIds) {
            ForEach(viewModel.savedItems) { item in
                ItemRowView(item: item)
                    .onTapGesture {
                        viewModel.tappedSideBar(item: item)
                    }
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
        .navigationTitle("SplitView Search")
#if os(iOS)
        // TODO: maybe it makes more sense to put this in DetailView or ContainerView 
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
}

#Preview("Sidebar View") {
    SideBarListView(viewModel: ViewModelPreviewData.sharedViewModel)
}
