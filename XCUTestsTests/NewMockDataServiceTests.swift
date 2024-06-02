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
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(dataService.items.count, items.count)
        
    }

}
