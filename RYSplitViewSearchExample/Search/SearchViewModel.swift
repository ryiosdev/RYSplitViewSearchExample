//
//  SearchViewModel.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 2/16/25.
//

import Foundation
import Observation
import SwiftData

enum SearchViewState {
    case searchingNotStarted
    case searchingNotFound
    case searchingWithSuggestions([ItemSearchResult])
    case error(String)
}

@Observable @MainActor
class SearchViewModel {
    // view inputs
    var searchText: String = "" {
        didSet {
            if searchText.count < 3 {
                self.searchViewState = .searchingNotStarted
            } else {
                let suggestions = self.searchData.searchForItems(searchText)
                if suggestions.isEmpty {
                    self.searchViewState = .searchingNotFound
                } else {
                    self.searchViewState = .searchingWithSuggestions(suggestions)
                }
            }
        }
    }
    
    // view outputs
    var searchViewState: SearchViewState = .searchingNotStarted
    
    @ObservationIgnored private var searchData: ItemSearchData
    
    init(_ searchData: ItemSearchData = MockItemSearchData()) {
        self.searchData = searchData
    }
    
    func searchSubmitAction() -> Item? {
        print("search submitted with search text : \(searchText)")
        var item: Item? = nil
        // First, look for exact match
        if let exactItem = searchData.getItemBy(name: searchText) {
            item = exactItem
        // Then, check if for previous suggestions,
        } else if case let .searchingWithSuggestions(suggestions) = searchViewState, let firstSuggestion = suggestions.first?.autoCompleteText {
            item = searchData.getItemBy(name: firstSuggestion)
        }
        return item
    }
}

