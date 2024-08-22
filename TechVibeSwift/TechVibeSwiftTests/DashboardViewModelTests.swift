//
//  DashboardViewModelTests.swift
//  TechVibeSwiftTests
//
//  Created by devireddy k on 22/08/24.
//

import XCTest
@testable import TechVibeSwift

class DashboardViewModelTests: XCTestCase {
    var viewModel: DashboardViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = DashboardViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testTapOnSourceItem() {
        let mockDelegate = MockDashboardViewModelDelegate()
        viewModel.delegate = mockDelegate
        viewModel.tapOnSourceItem(item: 0, source: "BBC News")
        XCTAssertEqual(mockDelegate.didTapOnSourceItemCalled, true)
        XCTAssertEqual(mockDelegate.tappedSource, "BBC News")
    }
    
    func testTapOnSearchButton() {
        let mockDelegate = MockDashboardViewModelDelegate()
        viewModel.delegate = mockDelegate
        viewModel.tapOnSearchButton(viewModel)
        XCTAssertEqual(mockDelegate.didTapOnSearchButtonCalled, true)
    }
    
}

class MockDashboardViewModelDelegate: DashboardViewModelDelegate {
    var didTapOnSourceItemCalled = false
    var tappedSource: String?
    
    func didTapOnSourceItem(item: Int?, source: String?, view: DashboardViewModel) {
        didTapOnSourceItemCalled = true
        tappedSource = source
    }
    
    var didTapOnSearchButtonCalled = false
    
    func didTapOnSearchButton(_ view: DashboardViewModel) {
        didTapOnSearchButtonCalled = true
    }
}
