//
//  DetailView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Binding var viewModel: ViewModel

    @Environment(\.dismissSearch) private var dismissSearch
    var body: some View {
        if let searched = viewModel.searchedItem {
            VStack {
#if os(macOS)
                VStack {
                    Text("Search result item:")
                    Text(searched.name)
                    //if not already saved, show the Save button
                    if !viewModel.savedItems.contains(where: { $0.name.lowercased() == searched.name.lowercased() } ) {
                        Button("Save") {
                            withAnimation {
                                //TODO: move to viewModel
                                viewModel.add(item: searched)
                                viewModel.selectedItem = searched
                                viewModel.searchText = ""
                                viewModel.searchedItem = nil
                                dismissSearch()
                            }
                        }
                    }
                }
                .navigationTitle(searched.name)
#endif
            }
        } else if let selectedItem = viewModel.selectedItem {
            VStack {
                Text("Selected item:")
                Text(selectedItem.name)
            }
            .navigationTitle(selectedItem.name)
        } else {
            Text("Select or Search for an item")
                .navigationBarBackButtonHidden(false)
        }
    }
}
