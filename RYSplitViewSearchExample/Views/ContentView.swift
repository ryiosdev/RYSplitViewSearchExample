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
#if os(iOS)
        .searchable(text: $viewModel.searchText,
                    isPresented: $viewModel.isSearchPresented,
                    placement: .navigationBarDrawer(displayMode:.always))
#elseif os(macOS)
        .searchable(text: $viewModel.searchText,
                    isPresented: $viewModel.isSearchPresented,
                    placement: .automatic )
#endif
        .searchSuggestions {
            SearchSuggestionsView(viewModel: viewModel)
        }
        .onSubmit(of: .search) {
            withAnimation {
                viewModel.onSubmitOfSearch()
            }
        }
    }    
}
