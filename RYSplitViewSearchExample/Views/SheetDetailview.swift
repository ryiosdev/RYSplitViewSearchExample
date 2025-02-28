//
//  SheetDetailview.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct SheetDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            if let searched = viewModel.searchedItem {
                VStack {
                    Text("Sheet search result item:")
                    Text(searched.name)
                }
                .navigationTitle(searched.name)
                .toolbar {
                    if !viewModel.isSearchedItemAlreadySaved() {
                        Button("Add") {
                            withAnimation {
                                viewModel.addToSavedItems(item: searched)
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview("Searched Item Detail" ) {
    SheetDetailView(viewModel: DetailPreviewData.searchedItemViewModel)
}
