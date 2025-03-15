//
//  ContentView.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all), preferredCompactColumn: .constant(.sidebar)){
            SideBarListView(viewModel: viewModel)
        } detail: {
            DetailView(viewModel: viewModel)
        }
#if os(macOS)
        .searchable(text: $viewModel.searchText,
                    placement: .automatic,
                    prompt: "Search by City Name")
#else
        .searchable(text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search by City Name")
#endif
        .searchSuggestions {
            ForEach(viewModel.searchedItemsByName) { item in
                ItemRowView(item: item)
                    .searchCompletion(item.name)
            }
        }
        .onSubmit(of: .search) {
            withAnimation {
                viewModel.onSubmitOfSearch()
            }
        }
    }
}

#Preview("Content View") {
    ContentView(viewModel: ViewModelPreviewData.sharedViewModel)
}
