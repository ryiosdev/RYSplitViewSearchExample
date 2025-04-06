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
        var inMemory = false
#if DEBUG
        //if within the preview or unit tests, use in mem storage
        if CommandLine.arguments.contains("debug_store_data_in_mem_only") {
            inMemory = true
        }
#endif        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return container
        } catch {
            //if you get here, on macOS delete the file in the commented code above, iOS delete app from simulator
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(RYSplitViewSearchExampleApp.sharedModelContainer)
    }
}
