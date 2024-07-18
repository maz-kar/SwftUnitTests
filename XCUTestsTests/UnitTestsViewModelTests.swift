//
//  UnitTestsViewModelTests.swift
//  XCUTestsTests
//
//  Created by Maziar Layeghkar on 01.06.24.
//

import XCTest
@testable import XCUTests
import Combine

final class UnitTestsViewModelTests: XCTestCase {
    
    var sut: UnitTestsViewModel!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        sut = UnitTestsViewModel(isPremium: Bool.random())
    }
    
    func test_isPremium_shouldBeTrue() {
        //Given
        let userIsPremium: Bool = true
        
        //When
        sut.isPremium = userIsPremium
        
        //Then
        XCTAssertTrue(sut.isPremium)
    }
    
    func test_isPremium_shouldBeFalse() {
        let userIsPremium: Bool = false
        sut.isPremium = userIsPremium
        
        XCTAssertFalse(sut.isPremium)
    }
    
    func test_isPremium_shouldBeInjectedValue() {
        let userIsPremium: Bool = Bool.random()
        sut.isPremium = userIsPremium
        
        XCTAssertEqual(sut.isPremium, userIsPremium)
    }
    
    func test_isPremium_shouldBeInjectedValue_stress() {
        for _ in 0..<10 {
            let userIsPremium: Bool = Bool.random()
            sut.isPremium = userIsPremium
            
            XCTAssertEqual(sut.isPremium, userIsPremium)
        }
    }
    
    func test_dataArray_shouldBeEmpty() {
        XCTAssertTrue(sut.dataArray.isEmpty)
        XCTAssertEqual(sut.dataArray.count, 0)
    }
    
    func test_addItem_shouldAddItemToDataArray_stress() {
        let loopCount: Int = Int.random(in: 1..<100)
        let randomString = UUID().uuidString
        
        for _ in 0..<loopCount {
            sut.addItem(item: randomString)
        }
        
        XCTAssertTrue(!sut.dataArray.isEmpty)
        XCTAssertEqual(sut.dataArray.count, loopCount)
    }
    
    func test_addItem_shouldNotAddItemEmptyString() {
        sut.addItem(item: "")
        
        XCTAssertTrue(sut.dataArray.isEmpty)
        XCTAssertEqual(sut.dataArray, [])
    }
    
    func test_selectedItem_shouldBeNilAtStart() {
        XCTAssertNil(sut.selectedItem)
    }
    
    func test_selectItem_whenInvalidItem_shouldBeNil() {
        sut.selectItem(item: UUID().uuidString)
        
        XCTAssertNil(sut.selectedItem)
    }
    
    func test_selectItem_shouldBeSetAgainToNil() {
        let newItem = UUID().uuidString
        
        sut.addItem(item: newItem)
        sut.selectItem(item: newItem)
        
        sut.selectItem(item: UUID().uuidString)
        
        XCTAssertNil(sut.selectedItem)
    }
    
    func test_selectItem_shouldBeSelected() {
        let newItem = UUID().uuidString
        
        sut.addItem(item: newItem)
        sut.selectItem(item: newItem)
        
        XCTAssertNotNil(sut.selectedItem)
        XCTAssertEqual(sut.selectedItem, newItem)
    }
    
    func test_selectItem_shouldBeSelected_stress() {
        let loopCount = Int.random(in: 1..<100)
        
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            sut.addItem(item: newItem)
        }
        let randomItem = sut.dataArray.randomElement() ?? ""
        sut.selectItem(item: randomItem)
        
        XCTAssertFalse(randomItem.isEmpty)
        XCTAssertNotNil(sut.selectedItem)
        XCTAssertEqual(sut.selectedItem, randomItem)
    }
    
    func test_saveItem_whenEmptyString_shouldThrowNoDataError() {
        let loopCount = Int.random(in: 1..<100)
        
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            sut.addItem(item: newItem)
        }
        
        XCTAssertThrowsError(try sut.saveItem(item: ""), "Should throw not data error.") { error in
            let returnedError = error as? UnitTestsViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestsViewModel.DataError.noData)
        }
    }
    
    func test_saveItem_shouldThrowItemNotFoundError() {
        let loopCount = Int.random(in: 1..<100)
        
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            sut.addItem(item: newItem)
        }
        
        do {
            try sut.saveItem(item: UUID().uuidString)
        } catch let error {
            let returnedError = error as? UnitTestsViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestsViewModel.DataError.itemNotFound)
        }
    }
    
    func test_saveItem_shouldSaveItem() {
        let loopCount = Int.random(in: 1..<100)
        
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            sut.addItem(item: newItem)
        }
        let randomItem = sut.dataArray.randomElement() ?? ""
        
        XCTAssertFalse(randomItem.isEmpty)
        XCTAssertNoThrow(try sut.saveItem(item: randomItem))
    }
    
    func test_saveItem_shouldSaveItem2() {
        let loopCount = Int.random(in: 1..<100)
        
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            sut.addItem(item: newItem)
        }
        let randomItem = sut.dataArray.randomElement() ?? ""
        
        XCTAssertFalse(randomItem.isEmpty)
        do {
            try sut.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
    }
    
    func test_downloadEscaping_shouldReturnItems() {
        sut.downloadEscaping()
        
        let expectation = XCTestExpectation(description: "Should return items after 3 seconds.")
        
        sut.$dataArray
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertGreaterThan(sut.dataArray.count, 0)
    }
    
    func test_downloadCombine_shouldReturnItems() {
        sut.downloadCombine()
        
        let expectation = XCTestExpectation(description: "Should return items after a second.")
        
        sut.$dataArray
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        XCTAssertGreaterThan(sut.dataArray.count, 0)
    }
    
    func test_selectedItem_givenInitialized_shouldBeNil() {
        XCTAssertNil(sut.selectedItem)
    }
    
    func test_selectedItem_givenNoMatch_shouldSelectedItemRemainNil() {
        let userInput = "something"
        sut.dataArray = ["somethingElse"]
        
        sut.selectItem(item: userInput)
        XCTAssertNil(sut.selectedItem)
    }
    
    //TODO: Fix this
    func test_selectedItem_givenAMatch_shouldSetSelectedItemToTheMatch() {
        let userInput = "something"
        sut.dataArray = [userInput]
        
//        XCTAssertEqual(sut.selectedItem, userInput)
//        XCTAssertNotNil(sut.selectedItem)
    }

}
