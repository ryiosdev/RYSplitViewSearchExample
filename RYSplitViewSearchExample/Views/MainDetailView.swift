//
//  MainDetailView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct MainDetailView: View {
    @Bindable var viewModel: ViewModel
    var body: some View {
        VStack {
            if let item = viewModel.selectedItem {
                ItemDetailView(item: item)
                    .navigationTitle(item.name)
                    .navigationBarBackButtonHidden(false)
#if os(iOS)
                    .navigationBarTitleDisplayMode(.large)
#endif
                if item.savedAt == nil {
                    Button("Add") {
                        withAnimation {
                            viewModel.saveDetailItem()
                        }
                    }
                }
            } else {
                Text("Select or Search for an item")
            }
        }
    }
}
