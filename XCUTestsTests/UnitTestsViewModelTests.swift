//
//  UnitTestsViewModelTests.swift
//  XCUTestsTests
//
//  Created by Maziar Layeghkar on 01.06.24.
//

import XCTest
@testable import XCUTests

final class UnitTestsViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        let viewModel = UnitTestsViewModel(isPremium: Bool.random())
        
        XCTAssertTrue(viewModel.dataArray.isEmpty)
        XCTAssertEqual(viewModel.dataArray.count, 0)
    }
    
    func test_addItem_shouldAddItemToDataArray_stress() {
        let viewModel = UnitTestsViewModel(isPremium: Bool.random())
        let loopCount: Int = Int.random(in: 1..<100)
        let randomString = UUID().uuidString
        
        for _ in 0..<loopCount {
            viewModel.addItem(item: randomString)
        }
        
        XCTAssertTrue(!viewModel.dataArray.isEmpty)
        XCTAssertEqual(viewModel.dataArray.count, loopCount)
    }
    
    func test_addItem_shouldNotAddItemEmptyString() {
        let viewModel = UnitTestsViewModel(isPremium: Bool.random())
        
        viewModel.addItem(item: "")
        
        XCTAssertTrue(viewModel.dataArray.isEmpty)
        XCTAssertEqual(viewModel.dataArray, [])
    }
    
    func test_selectedItem_shouldBeNilAtStart() {
        let vm = UnitTestsViewModel(isPremium: Bool.random())
        
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_selectItem_whenInvalidItem_shouldBeNil() {
        let vm = UnitTestsViewModel(isPremium: Bool.random())
        
        vm.selectItem(item: UUID().uuidString)
        
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_selectItem_shouldBeSelected() {
        let vm = UnitTestsViewModel(isPremium: Bool.random())
        let newItem = UUID().uuidString
        
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, newItem)
    }
    
    func test_selectItem_shouldBeSetAgainToNil() {
        let vm = UnitTestsViewModel(isPremium: Bool.random())
        let newItem = UUID().uuidString
        
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        vm.selectItem(item: UUID().uuidString)
        
        XCTAssertNil(vm.selectedItem)
    }
    
}
