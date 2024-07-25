//
//  NewMockDataServiceTests.swift
//  XCUTestsTests
//
//  Created by Maziar Layeghkar on 02.06.24.
//

import XCTest
@testable import XCUTests
import Combine

final class NewMockDataServiceTests: XCTestCase {
    var sut: NewMockDataService!
    var cancellables = Set<AnyCancellable>()
    
    func test_init_shouldSetValuesCorrectly() {
        let items: [String]? = nil
        let items2: [String]? = []
        let items3: [String]? = [UUID().uuidString, UUID().uuidString]
        
        let dataService = NewMockDataService(items: items)
        let dataService2 = NewMockDataService(items: items2)
        let dataService3 = NewMockDataService(items: items3)
        
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertTrue(dataService2.items.isEmpty)
        XCTAssertEqual(dataService3.items.count, items3?.count)
    }
    
    func test_downloadWithEscaping_shouldReturnValues() {
        let dataService = NewMockDataService(items: nil)
        let expectation = XCTestExpectation()
        var items: [String] = []
        
        dataService.downloadWithEscaping { returnedItems in
            items = returnedItems
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(dataService.items.count, items.count)
    }
    
    func test_downloadWithEscaping_givenNonNilItemInInit_shouldReturnItems() {
        let expectation = XCTestExpectation()
        let newMockDataService = NewMockDataService(items: [UUID().uuidString])
        var items: [String] = []
        
        newMockDataService.downloadWithEscaping { returnedItems in
            items = returnedItems
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(items.count, 1)
    }
    
    func test_downloadWithCombine_shouldReturnValues() {
        let dataService = NewMockDataService(items: nil)
        let expectation = XCTestExpectation()
        var items: [String] = []
        
        
        dataService.downloadWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            } receiveValue: { returnedItems in
                items = returnedItems
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(dataService.items.count, items.count)
    }
    
    func test_downloadWithCombine_shouldFail() {
        let dataService = NewMockDataService(items: [])
        let expectation = XCTestExpectation(description: "Does throw an error")
        let expectation2 = XCTestExpectation(description: "Does throw URLError.badServeResponse")
        var items: [String] = []
        
        
        dataService.downloadWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(let error):
                    expectation.fulfill()
                    
                    if error as? URLError == URLError(.badServerResponse) {
                        expectation2.fulfill()
                    }
                }
            } receiveValue: { returnedItems in
                items = returnedItems
            }
            .store(in: &cancellables)
        
        wait(for: [expectation, expectation2], timeout: 5)
        
        XCTAssertEqual(dataService.items.count, items.count)
    }
}
