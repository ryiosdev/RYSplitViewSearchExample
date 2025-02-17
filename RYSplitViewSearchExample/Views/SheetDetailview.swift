//
//  SheetDetailview.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct SheetDetailView: View {
    @Binding var viewModel: ViewModel
    
    @Environment(\.dismissSearch) private var dismissSearch

    var body: some View {
        NavigationStack {
            if let searched = viewModel.searchedItem {
                VStack {
                    Text("Sheet search result item:")
                    Text(searched.name)
                }
                .navigationTitle(searched.name)
                .toolbar {
                    // TODO: move to viewModel function of which button to show..
                    if !viewModel.savedItems.contains(where: { $0.name.lowercased() == searched.name.lowercased() } ) {
                        Button("Save") {
                            withAnimation {
                                viewModel.add(item: searched)
                                dismissSearch()
                                viewModel.selectedItem = searched
                                viewModel.isDetailSheetPresented = false
                            }
                        }
                    }
                }
            }
        }
    }
}
