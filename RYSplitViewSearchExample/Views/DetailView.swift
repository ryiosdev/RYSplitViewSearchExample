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
        VStack {
            if let searched = viewModel.searchedItem {
#if os(macOS)
                VStack {
                    Text("Search result item:")
                    Text(searched.name)
                    //if not already saved, show the Save button
                    if !viewModel.savedItems.contains(where: { $0.name.lowercased() == searched.name.lowercased() } ) {
                        Button("Add") {
                            withAnimation {
                                viewModel.add(item: searched)
                                dismissSearch()
                            }
                        }
                    }
                }
                .navigationTitle(searched.name)
#endif
            }
            else if !viewModel.selectedItemIds.isEmpty {
                if let firstId = viewModel.selectedItemIds.first,
                    let selectedItem = viewModel.savedItems.first(where: { $0.id == firstId }) {
                    VStack {
                        Text("Selected item:")
                        Text(selectedItem.name)
                    }
                    .navigationTitle(selectedItem.name)
                }
            } else {
                Text("Select or Search for an item")
                    .navigationBarBackButtonHidden(false)
            }
        }
    }
}
