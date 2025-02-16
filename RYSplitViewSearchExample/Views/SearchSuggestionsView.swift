//
//  SearchSuggestionsView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct SearchSuggestionsView: View {
    @Binding var searchText: String
    var searchItems: [Item]

    @Query private var items: [Item]

    var body: some View {
        ForEach(searchResults()) { newItem in
            Text(newItem.name)
            .searchCompletion(newItem.name)
        }
    }
    
    func searchResults() -> [Item] {
        let results = searchItems.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
        
        return results.filter { !items.contains($0) }
    }
}
