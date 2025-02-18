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
        VStack {
            List(viewModel.savedItems, id: \.name, selection: $viewModel.selectedItem) { item in
                // HACK .onDelete (swipe to delete) seems to only works on ForEach
                ForEach([item]) { item in
                    NavigationLink(item.name, value: item)
                }
                // Swipe to delete
                .onDelete(perform: deleteItems)
                // macOS right click delete
#if os(macOS)
                .contextMenu {
                    if let item = viewModel.selectedItem {
                        Button("Delete") {
                            withAnimation {
                                viewModel.delete(item: item)
                                viewModel.selectedItem = nil
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
#if os(iOS)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onChange(of: viewModel.searchedItem, initial: true) { (oldValue, newValue) in
            if newValue != nil  {
                viewModel.isDetailSheetPresented = true
            } else {
                viewModel.isDetailSheetPresented = false
            }
        }
        .sheet(isPresented: $viewModel.isDetailSheetPresented) {
            SheetDetailView(viewModel: $viewModel)
            .onDisappear {
                viewModel.searchedItem = nil
            }
        }
#endif
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let item = viewModel.savedItems[index]
                if item == viewModel.selectedItem {
                    viewModel.selectedItem = nil
                }
                viewModel.delete(item: item)
            }
        }
    }
}
