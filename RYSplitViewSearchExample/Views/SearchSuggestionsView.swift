//
//  SearchSuggestionsView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI

struct SearchSuggestionsView: View {
    @Binding var searchText: String
    var searchItems: [Item]

    var body: some View {
        //TODO: filter out currently selected
        ForEach(searchItems.filter({ $0.name.lowercased().contains(searchText.lowercased()) })) { newItem in
            Text(newItem.name)
            .searchCompletion(newItem.name)
        }
    }
}
