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
        VStack(alignment: .leading) {
            Text(item.name)
            if let date = item.savedAt {
                Text("Saved: \(date, style: .date)")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    @Previewable @State var item = Item("Test")
    ItemRowView(item: item)
}
