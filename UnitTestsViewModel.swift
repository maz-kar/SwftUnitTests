//
//  UnitTestsViewModel.swift
//  XCUTests
//
//  Created by Maziar Layeghkar on 01.06.24.
//

import Foundation
import SwiftUI
import Combine

class UnitTestsViewModel: ObservableObject {
    
    @Published var isPremium: Bool
    @Published var dataArray: [String] = []
    @Published var selectedItem: String? = nil
    let dataService: NewDataServiceProtocol
    
    var cancellables = Set<AnyCancellable>()
    
    init(isPremium: Bool, dataService: NewDataServiceProtocol = NewMockDataService(items: nil)) {
        self.isPremium = isPremium
        self.dataService = dataService
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
    
    func downloadEscaping() {
        dataService.downloadWithEscaping { [weak self] returnedItems in
            self?.dataArray = returnedItems
        }
    }
    
    func downloadCombine() {
        dataService.downloadWithCombine()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                self?.dataArray = returnedItems
            }
            .store(in: &cancellables)

    }
    
    enum DataError: LocalizedError {
        case noData
        case itemNotFound
    }
    
}
