//
//  UnitTestsViewModelTests.swift
//  XCUTestsTests
//
//  Created by Maziar Layeghkar on 01.06.24.
//

import XCTest
@testable import XCUTests

final class UnitTestsViewModelTests: XCTestCase {
    
    var sut: UnitTestsViewModel!
    
    override func setUp() {
        sut = UnitTestsViewModel(isPremium: Bool.random())
    }
    
    func test_isPremium_shouldBeTrue() {
        //Given
        let userIsPremium: Bool = true
        
        //When
        let viewModel = UnitTestsViewModel(isPremium: userIsPremium)
        
        //Then
        XCTAssertTrue(viewModel.isPremium)
    }
    
    func test_isPremium_shouldBeFalse() {
        let userIsPremium: Bool = false
        let viewModel = UnitTestsViewModel(isPremium: userIsPremium)
        
        XCTAssertFalse(viewModel.isPremium)
    }
    
    func test_isPremium_shouldBeInjectedValue() {
        let userIsPremium: Bool = Bool.random()
        let viewModel = UnitTestsViewModel(isPremium: userIsPremium)
        
        XCTAssertEqual(viewModel.isPremium, userIsPremium)
    }
    
    func test_isPremium_shouldBeInjectedValue_stress() {
        for _ in 0..<10 {
            let userIsPremium: Bool = Bool.random()
            let viewModel = UnitTestsViewModel(isPremium: userIsPremium)
            
            XCTAssertEqual(viewModel.isPremium, userIsPremium)
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
        
        XCTAssertNotNil(sut.selectedItem)
        XCTAssertEqual(sut.selectedItem, randomItem)
    }
    
    func test_saveItem_whenEmptyString_shouldThrowError() {
        
    }
    
}
