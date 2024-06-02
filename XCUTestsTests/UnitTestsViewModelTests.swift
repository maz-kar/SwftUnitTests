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
}
