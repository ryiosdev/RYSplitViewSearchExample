//
//  ListView.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 3/31/25.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedItem: Item?

    private var didSavePublisher: NotificationCenter.Publisher {
        NotificationCenter.default
            .publisher(for: ModelContext.didSave, object: modelContext)
    }
    
    init(selectedItem: Binding<Item?>) {
        _selectedItem = selectedItem
    }
    
    var body: some View {
        @State var viewModel = ListViewModel(modelContext: modelContext)

        List(selection: $selectedItem) {
            if case let .loaded(items) = viewModel.listViewState {
                ForEach(items) { item in
                    NavigationLink(value: item) {
                        ItemRowView(item: item)
                    }
                }
                .onDelete { indices in
                    for index in indices {
                        let item = items[index]
                        viewModel.delete(item: item)
                    }
                }
            }
        }
        .refreshable {
            viewModel.refreshItemsList()
        }
        .onReceive(didSavePublisher) { _ in
            viewModel.refreshItemsList()
        }
        .overlay {
            if case let .loaded(items) = viewModel.listViewState, items.isEmpty {
                ContentUnavailableView {
                    Text("No Items")
                }
                
            } else if case .loading = viewModel.listViewState {
                ContentUnavailableView {
                    Text("Loading Items...")
                }
            } else if case let .error(errorMessage) = viewModel.listViewState {
                ContentUnavailableView {
                    Text(errorMessage)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedItem: Item?
    ListView(selectedItem: $selectedItem)
        .modelContainer(for: Item.self, inMemory: true)
}
