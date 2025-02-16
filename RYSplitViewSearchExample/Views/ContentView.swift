//
//  ContentView.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var viewModel: ViewModel
    
    init(modelContext: ModelContext) {
          let viewModel = ViewModel(modelContext: modelContext)
          _viewModel = State(initialValue: viewModel)
      }
    
    var body: some View {
        NavigationSplitView {
            SideBarListView(viewModel: $viewModel)
        } detail: {
            DetailView(viewModel: $viewModel)
        }
#if os(macOS)
        .searchable(text: $viewModel.searchText,
                    isPresented: $viewModel.isSearchPresented,
                    placement: .automatic )

#else
        .searchable(text: $viewModel.searchText,
                    isPresented: $viewModel.isSearchPresented,
                    .navigationBarDrawer(displayMode:.always))
#endif

        .searchSuggestions {
            SearchSuggestionsView(viewModel: viewModel)
        }
        .onSubmit(of: .search) {
            onSubmitSearch()
        }
    }
    
    //on submit (enter key), show the first searched suggestion, if it exist
    private func onSubmitSearch() {
        let searchText = viewModel.searchText
        let searchResults = viewModel.searchItemsByName
        print("onSearchSbumit '\(searchText)' returned : \(searchResults.map(\.name))")
        
        if let firstItem = searchResults.first {
            withAnimation {
                viewModel.searchText = firstItem.name
                viewModel.searchedItem = firstItem
#if os(macOS)
                //deselect the macOS side bar is
                viewModel.selectedItem = nil
#endif
            }
        }
        viewModel.isSearchPresented = false
    }
}
