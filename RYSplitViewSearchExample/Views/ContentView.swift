//
//  ContentView.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all), preferredCompactColumn: .constant(.sidebar)){
            SideBarListView(viewModel: viewModel)
        } detail: {
            DetailView(viewModel: viewModel)
        }
#if os(macOS)
        .searchable(text: $viewModel.searchText,
                    placement: .automatic,
                    prompt: "Search by City Name")
#else
        .searchable(text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search by City Name")
#endif
        .searchSuggestions {
            ForEach(viewModel.searchedItemsByName) { item in
                ItemRowView(item: item)
                    .searchCompletion(item.name)
            }
        }
        .onSubmit(of: .search) {
            withAnimation {
                viewModel.onSubmitOfSearch()
            }
        }
    }
}

// MARK: Preview
@MainActor
class ViewModelPreviewData {
    static let sharedModelContainer: ModelContainer = {
        do {
            let schema = Schema([
                Item.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            for i in 1...5 {
                let item = Item("City \(i)")
                item.savedAt = Date()
                container.mainContext.insert(item)
            }
            return container
        } catch {
            //if you get here, on macOS delete the file in the commented code above, iOS delete app from simulator
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    static let sharedViewModel: ViewModel = {
        var viewModel = ViewModel(modelContext: ViewModelPreviewData.sharedModelContainer.mainContext)
        viewModel.selectedItemIds = []
        return viewModel
    }()
}

#Preview("Content View") {
    ContentView(viewModel: ViewModelPreviewData.sharedViewModel)
}
