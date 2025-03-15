//
//  ViewModelPreviewData.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 3/15/25.
//

import Foundation
import SwiftData

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
