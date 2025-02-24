//
//  SearchSuggestionView.swift
//  test
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct ItemRowView: View {
    let item: Item
    
    var body: some View {
        Label(item.name, systemImage: "location.circle")
    }
}

#Preview {
    @Previewable @State var item = Item("Test")
    ItemRowView(item: item)
}
