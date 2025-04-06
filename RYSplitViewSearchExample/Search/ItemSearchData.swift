//
//  ItemSearchData.swift
//  RYSplitViewSearchExample
//
//  Created by Ryan Young on 4/4/25.
//

import Foundation

protocol ItemSearchData {
    func searchForItems(_ searchString: String) -> [ItemSearchResult]
    func getItemBy(name: String) -> Item?
}

final class MockItemSearchData {
    enum MockItemFile: String {
        case items = "items"
        case itemsEmpty = "items-empty"
        case itemsCorrupt = "items-corrupt"
    }
    
    private var items = [Item]()
    
    init(_ file: MockItemFile = .items) {
        guard let url = Bundle.main.url(forResource: file.rawValue, withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            items = try Item.itemsFrom(data: data)
        } catch {
            print("error loading mock data : \(error)")
        }
    }
}

extension MockItemSearchData: ItemSearchData {
    func searchForItems(_ searchString: String) -> [ItemSearchResult] {
        let results = items.map { item in
            ItemSearchResult(itemID: item.id, autoCompleteText: item.name)
        }.filter { item in
            item.autoCompleteText.lowercased().contains(searchString.lowercased())
        }
        return results
    }
    
    func getItemBy(name: String) -> Item? {
        items.first(where: { $0.name == name })
    }
}
