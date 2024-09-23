
import Foundation
import Combine
import SwiftUI
import XCTest
@testable import XCUTests

final class UnitTestsViewModelTests: XCTestCase {
    
    var sut: UnitTestsViewModel!
    
    override func setUp() {
        sut = UnitTestsViewModel(isPremium: Bool.random())
    }
    
    func test_isPremium_shouldBeTrue() {
        sut.isPremium = true
        XCTAssertTrue(sut.isPremium)
    }
    
    func test_isPremium_shouldBeFalse() {
        sut.isPremium = false
        XCTAssertFalse(sut.isPremium)
    }
    
    func test_dataArray_shouldBeEmptyStrArrAtStart() {
        XCTAssertTrue(sut.dataArray.isEmpty)
    }
    
    func test_addItem_givenEmptyItem_shouldReturnEmptyDataArray() {
        let userItem = ""
        sut.addItem(item: userItem)
        XCTAssertTrue(sut.dataArray.isEmpty)
    }
    
    func test_addItem_givenNonEmptyItem_shouldSetItemToDataArray() {
        let userItem = "test"
        sut.addItem(item: userItem)
        XCTAssertTrue(!sut.dataArray.isEmpty)
        XCTAssertEqual(sut.dataArray, ["test"])
    }
    
    func test_selectedItem_shouldBeNilAtStart() {
        XCTAssertNil(sut.selectedItem)
    }
    
    func test_selectItem_givenAlreadyExistingItem_shouldSetSelectedItemToGivenItem() {
        let userItem = "test"
        sut.addItem(item: userItem)
        
        sut.selectItem(item: userItem)
        
        XCTAssertTrue(!sut.dataArray.isEmpty)
        XCTAssertEqual(sut.selectedItem, userItem)
    }
    
    func test_selectItem_givenNonExistingItem_shouldNotSetSelectedItem() {
        let userItem = "AnotherTest"
        sut.addItem(item: "test")
        
        sut.selectItem(item: userItem)
        
        XCTAssertNil(sut.selectedItem)
    }
    
    func test_saveItem_givenEmptyItem_shouldThrowNoDataError() {
        let userItem = ""
        
//        do {
//            try sut.saveItem(item: userItem)
//        } catch let error {
//            let returnedError = error as? UnitTestsViewModel.DataError
//            XCTAssertEqual(returnedError, UnitTestsViewModel.DataError.noData)
//        }
        
        XCTAssertThrowsError(try sut.saveItem(item: userItem)) { error in
            let returnedError = error as? UnitTestsViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestsViewModel.DataError.noData)
        }
    }
    
    func test_saveItem_givenNonExistingItem_shouldThrowItemNotFoundError() {
        let userItem = "test"
        sut.addItem(item: "AnotherTest")
        
//        do {
//            try sut.saveItem(item: userItem)
//        } catch let error {
//            let returnedError = error as? UnitTestsViewModel.DataError
//            XCTAssertEqual(returnedError, UnitTestsViewModel.DataError.itemNotFound)
//        }
        
        XCTAssertThrowsError(try sut.saveItem(item: userItem)) { error in
            let returnedError = error as? UnitTestsViewModel.DataError
            XCTAssertEqual(returnedError, UnitTestsViewModel.DataError.itemNotFound)
        }
    }
    
    func test_saveItem_givenExistingItem_shouldPrintTheSaveStatement() {
        let userItem = "test"
        
        sut.addItem(item: userItem)
        
//        do {
//            try sut.saveItem(item: userItem)
//        } catch {
//            XCTFail()
//        }
        
        XCTAssertNoThrow(try sut.saveItem(item: userItem), "Save test here.")
    }
    
}
