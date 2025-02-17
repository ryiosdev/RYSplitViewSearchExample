//
//  SearchSuggestionsView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct SearchSuggestionsView: View {
    var viewModel: ViewModel

    var body: some View {
        let items = viewModel.searchedItemsByName
        print("suggesting: \(items.map(\.name))")
        return ForEach(items) { item in
            Text(item.name)
            .searchCompletion(item.name)
        }
    }
}
