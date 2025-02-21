//
//  DetailView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.dismissSearch) private var dismissSearch
    @Bindable var viewModel: ViewModel

    var body: some View {
        VStack {
            if let searched = viewModel.searchedItem, !viewModel.isDetailSheetPresented {
                VStack {
                    Text("Search result item:")
                    Text(searched.name)
                    //if not already saved, show the Save button
                    if !viewModel.savedItems.contains(where: { $0.name.lowercased() == searched.name.lowercased() } ) {
                        Button("Add") {
                            withAnimation {
                                viewModel.addToSavedItems(item: searched)
                                dismissSearch()
                            }
                        }
                    }
                }
            }
            else if let selectedItem = viewModel.firstSelectedItem() {
                VStack {
                    Text("Selected item:")
                    Text(selectedItem.name)
                    Text(selectedItem.savedAt?.description ?? "")
                        .foregroundStyle(.secondary)
                }
                .navigationTitle(selectedItem.name)
                
            } else {
                Text("Select or Search for an item")
                    .navigationBarBackButtonHidden(false)
            }
        }
    }
}
