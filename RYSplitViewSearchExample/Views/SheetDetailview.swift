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
    @Environment(\.dismissSearch) private var dismissSearch
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            if let item = viewModel.selectedItem {
                VStack {
                    Text("Sheet detail item:")
                    Text(item.name)
                }
                .navigationTitle(item.name)
                .toolbar {
                    if item.savedAt == nil {
                        Button("Add") {
                            withAnimation {
                                viewModel.saveDetailItem()
                                dismiss()
                                dismissSearch()
                            }
                        }
                    }
                }
            }
        }
    }
}
