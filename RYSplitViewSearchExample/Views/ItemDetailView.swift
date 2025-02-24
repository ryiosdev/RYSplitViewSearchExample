//
//  ItemDetailView.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 2/23/25.
//

import SwiftUI

struct ItemDetailView: View {
    var item: Item
    
    var body: some View {
        VStack {
            Text(item.name)
            Text("Craeted : \(item.createdAt.formatted())")
        }
        .padding()
        .background(Color.gray.opacity(0.5))
        .cornerRadius(5)
    }
}

#Preview {
    ItemDetailView(item: Item("test"))
}
