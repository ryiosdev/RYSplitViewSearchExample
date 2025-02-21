//
//  SearchSuggestionView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct SearchSuggestionView: View {
    let suggestedItem: Item
    
    var body: some View {
        Text(suggestedItem.name)
    }
}
