//
//  RYSplitViewSearchExampleTests.swift
//  RYSplitViewSearchExampleTests
//
//  Created by Ryan Young on 2/15/25.
//

import Testing
import Foundation

@testable import RYSplitViewSearchExample

struct ModelTests {
    struct ItemTests {
        @Test func initProperties() {
            let item = Item(name: "Test")
            #expect(item.name == "Test")
            // Test if auto generated Date is close enough.
            #expect(item.createdAt < Date.now.addingTimeInterval(10))
            #expect(item.createdAt > Date.now.addingTimeInterval(-10))
        }
    }
}

struct ViewModelTests {
    // TODO: add more tests
    @Test func example() {
        #expect(true)
    }
}

