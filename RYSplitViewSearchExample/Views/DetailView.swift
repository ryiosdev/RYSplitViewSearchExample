//
//  DetailView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Bindable var viewModel: ViewModel

    var body: some View {
        ZStack {
            if !viewModel.isSheetDetailPresented, let searched = viewModel.searchedItem {
                VStack {
                    Text("Search result item:")
                    Text(searched.name)
                    //if not already saved, show the Save button
                    if !viewModel.savedItems.contains(where: { $0.name.lowercased() == searched.name.lowercased() } ) {
                        Button("Add") {
                            withAnimation {
                                viewModel.addToSavedItems(item: searched)
                            }
                        }
                    }
                }
            }
            else if let selectedItem = viewModel.firstSelectedItem() {
                VStack {
                    Text("Selected item:")
                    Text(selectedItem.name)
                    Text("Saved : \(selectedItem.savedAt?.description ?? "")")
                        .foregroundStyle(.secondary)
                }
                .navigationTitle(selectedItem.name)
#if os(iOS)
                .navigationBarTitleDisplayMode(.large)
#endif
            } else {
                Text("Select or Search for an item")
            }
        }
    }
}

// MARK: Preview
@MainActor
class DetailPreviewData {
    static let selectedItemViewModel: ViewModel = {
        var viewModel = ViewModel(modelContext: ViewModelPreviewData.sharedModelContainer.mainContext)
        viewModel.selectedItemIds = [viewModel.savedItems.first!.id]
        return viewModel
    }()
    
    static let searchedItemViewModel: ViewModel = {
        var viewModel = ViewModel(modelContext: ViewModelPreviewData.sharedModelContainer.mainContext)
        viewModel.searchedItem = Item("New City")
        return viewModel
    }()
}

#Preview("Selected Item Detail") {
    DetailView(viewModel: DetailPreviewData.selectedItemViewModel)
}

#Preview("Searched Item Detail") {
    DetailView(viewModel: DetailPreviewData.searchedItemViewModel)
}
