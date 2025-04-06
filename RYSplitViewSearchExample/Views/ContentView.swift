//
//  ContentView.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var selectedItem: Item?
    @State private var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationSplitView {
            NavigationStack {
                ListView(selectedItem: $selectedItem)
            }
        } detail: {
            NavigationStack {
                ItemDetailView(item: $selectedItem)
                    .itemDidSave { item in
                        print("ContentView's saved item closure for \(item.name)")
                    }
                    .itemDidDelete { item in
                        print("ContentView's deleted item closure for \(item.name)")
                    }
            }
        }
        .searchable(text: $searchViewModel.searchText,
                    placement: .automatic,
                    prompt: "Search by City Name")
        .searchSuggestions {
            searchSuggestions()
        }
        .onSubmit(of: .search) {
            if let item = searchViewModel.searchSubmitAction() {
                print("search item to present or navigate to : \(item.name)")
                // setting `selectedItem` pushes the it onto the NavigationSplitView's proper nav stack automagically.
                selectedItem = item
            }
        }
        .overlay(alignment: .bottom) {
            debugView()
        }
    }
    
    @ViewBuilder
    private func searchSuggestions() -> some View {
        if case .searchingNotStarted = searchViewModel.searchViewState {
            EmptyView()
        } else if case let .searchingWithSuggestions(results) = searchViewModel.searchViewState {
            ForEach(results, id:\.self) { result in
                Text(formattedSearchSuggestion(result))
                    .searchCompletion(result.autoCompleteText)
            }
        } else if case .searchingNotFound = searchViewModel.searchViewState {
            Text("\"\(searchViewModel.searchText)\" not found")
                .font(.caption)
        } else if case let .error(errorMessage) = searchViewModel.searchViewState {
            Text("Error : \(errorMessage)")
                .font(.caption)
        }
    }
    
    private func formattedSearchSuggestion(_ result: ItemSearchResult) -> AttributedString {
        var attributedString = AttributedString(result.autoCompleteText)
        attributedString.foregroundColor = .label
        
        if let range = attributedString.range(of: searchViewModel.searchText,
                                              options: [.caseInsensitive]) {
            attributedString[range].foregroundColor = .accent
            return attributedString
        } else {
            return attributedString
        }
    }
    
    @ViewBuilder
    private func debugView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("selectedItem = \(selectedItem?.name ?? "")")
        }
        .font(.caption)
    }
}

#Preview("Content View") {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
