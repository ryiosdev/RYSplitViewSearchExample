//
//  ItemDetailView.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 3/31/25.
//

import SwiftUI
import SwiftData

struct ItemDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismissSearch) private var dismissSearch
    
    @Binding var item: Item?
    
    private var didSaveClosure: ((Item) -> ())? = nil
    private var didDeleteClosure: ((Item) -> ())? = nil
    
    init(item: Binding<Item?>) {
        _item = item
        didSaveClosure = nil
        didDeleteClosure = nil
    }
    
    var body: some View {
        @State var viewModel = ItemDetailViewModel(item: item, modelContext: modelContext)
        
        if case let .error(errorMessage) = viewModel.itemDetailState {
            ContentUnavailableView {
                Text(errorMessage)
            }
        } else {
            if let item = item {
                VStack {
                    Text(item.name)
                        .font(.title)
                    Text(item.id.uuidString)
                        .font(.caption)
                    
                    if case let .saved(item) = viewModel.itemDetailState {
                        if let savedAt = item.savedAt {
                            Text("Saved: \(savedAt, format: Date.FormatStyle(date: .numeric, time: .standard))")
                                .padding()
                        }
                        Button("Delete") {
                            viewModel.delete()
                            didDeleteClosure?(item)
                        }
                    } else if case .unsaved(item) = viewModel.itemDetailState {
                        Button("Save") {
                            viewModel.save()
                            dismissSearch()
                            didSaveClosure?(item)
                        }
                    }
                }
                .navigationTitle(item.name)
            } else {
                Text("No item selected.")
            }
        }
    }

    func itemDidSave(_ closure: @escaping (Item) -> ()) -> ItemDetailView {
        var itemDetailView = self
        itemDetailView.didSaveClosure = closure
        return itemDetailView
    }
    
    func itemDidDelete(_ closure: @escaping (Item) -> ()) -> ItemDetailView {
        var itemDetailView = self
        itemDetailView.didDeleteClosure = closure
        return itemDetailView
    }
}

#Preview {
    @Previewable @State var item: Item? = Item("Test Item")
    ItemDetailView(item: $item)
        .modelContainer(for: Item.self, inMemory: true)
}
