//
//  UnitTestsViewModel.swift
//  XCUTests
//
//  Created by Maziar Layeghkar on 01.06.24.
//

import Foundation
import SwiftUI
import Combine

protocol NewDataServiceProtocol {
    func downloadWithEscaping(completion: @escaping (_ items: [String]) -> ())
    func downloadWithCombine() -> AnyPublisher<[String], Error>
    
}

class MockNewDataService: NewDataServiceProtocol {
    
    let items: [String]
    
    init(items: [String]?) {
        self.items = items ?? [
            "ONE", "TWO", "THREE"
        ]
    }
    
    func downloadWithEscaping(completion: @escaping (_ items: [String]) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(self.items)
        }
    }
    
    func downloadWithCombine() -> AnyPublisher<[String], Error> {
        Just(items)
            .tryMap({ returnedItems in
                <#code#>
            })
            .eraseToAnyPublisher()
    }
    
}

class UnitTestsViewModel: ObservableObject {
    
    @Published var isPremium: Bool
    @Published var dataArray: [String] = []
    @Published var selectedItem: String? = nil
    
    init(isPremium: Bool) {
        self.isPremium = isPremium
    }
    
    func addItem(item: String) {
        guard !item.isEmpty else { return }
        self.dataArray.append(item)
    }
    
    func selectItem(item: String) {
        if let x = dataArray.first(where: { $0 == item }) {
            self.selectedItem = x
        } else {
            self.selectedItem = nil
        }
    }
    
    func saveItem(item: String) throws {
        guard !item.isEmpty else {
            throw DataError.noData
        }
        
        if let x = dataArray.first(where: { $0 == item }) {
            print("Save \(x) here.")
        } else {
            throw DataError.itemNotFound
        }
    }
    
    enum DataError: LocalizedError {
        case noData
        case itemNotFound
    }
    
}
