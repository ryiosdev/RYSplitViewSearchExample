//
//  RYSplitViewSearchExampleApp.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 2/15/25.
//

import SwiftUI
import SwiftData

@main
struct RYSplitViewSearchExampleApp: App {
    static let sharedModelContainer: ModelContainer = {
        
//        let urlApp = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last
//        let url = urlApp!.appendingPathComponent("default.store")
//        if FileManager.default.fileExists(atPath: url.path) {
//            print("macOS: delete the swiftData .store* files here if crash on launch: \(url.absoluteString)")
//        }
        
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return container
        } catch {
            //if you get here, on macOS delete the file in the commented code above, iOS delete app from simulator
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State var sharedViewModel = ViewModel(modelContext: RYSplitViewSearchExampleApp.sharedModelContainer.mainContext)

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: sharedViewModel)
        }
        .modelContainer(RYSplitViewSearchExampleApp.sharedModelContainer)
    }
}
