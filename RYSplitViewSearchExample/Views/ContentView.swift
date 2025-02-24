//
//  ContentView.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var viewModel: ViewModel
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationSplitView {
            SideBarListView(viewModel: viewModel)
        } detail: {
            MainDetailView(viewModel: viewModel)
        }
        .onChange(of: horizontalSizeClass) {
            print("is compact:  \(horizontalSizeClass == .compact)")
        }

#if os(macOS)
        .searchable(text: $viewModel.searchText)
#else
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always),  prompt: "Search by City Name")
#endif
        .onSubmit(of: .search) {
            viewModel.onSubmitOfSearch()
        }
        .searchSuggestions {
            ForEach(viewModel.suggestionsForCurrentSearch(), id: \.self) { city in
                Text(city)
                    .searchCompletion(city)
            }
        }
    }
}

//@MainActor
//class PreviewData {
//    static func modelContext() -> ModelContext {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try! ModelContainer(for: Item.self, configurations: config)
//        let context = container.mainContext
//
//        for i in 1..<10 {
//            let item = Item("City Name \(i)")
//            context.insert(item)
//        }
//        return context
//    }
//}
//
//#Preview {
//    ContentView(modelContext: PreviewData.modelContext())
//}
