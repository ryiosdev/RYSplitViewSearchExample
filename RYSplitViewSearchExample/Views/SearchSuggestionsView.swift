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
        print("suggesting: \(viewModel.searchItemsByName.map(\.name))")
        return ForEach(viewModel.searchItemsByName) { item in
            Text(item.name)
            .searchCompletion(item.name)
        }
    }
}
