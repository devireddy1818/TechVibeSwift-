//
//  DashboardViewControllerTests.swift
//  TechVibeSwiftTests
//
//  Created by devireddy k on 22/08/24.
//

import XCTest
@testable import TechVibeSwift

class MockDashboardViewModel: DashboardViewModel {
    var isGetAllSourcesCalled = false
    var isGetTopHeadlinesCalled = false
    var isTapOnSourceItemCalled = false
    var isTapOnSearchButtonCalled = false
    let mockSource = Source(
        category: "general",
        country: "us",
        description: "Mock Description",
        id: "1",
        language: "en",
        name: "Mock Source",
        url: "https://example.com"
    )
    override func getAllSources(category: String? = nil, completion: @escaping ([Source]) -> Void) {
        isGetAllSourcesCalled = true
       
        completion([mockSource])
    }

    override func getTopHeadlines(country: String? = nil, category: String? = nil, completion: @escaping ([Article]) -> Void) {
        isGetTopHeadlinesCalled = true
        completion([Article(author: "Author", content: "Content", description: "Description", publishedAt: "2024-08-21T00:15:35Z", source: mockSource, title: "Title", url: "https://example.com", urlToImage: "https://example.com/image.jpg")])
    }

    override func tapOnSourceItem(item: Int?, source: String?) {
        isTapOnSourceItemCalled = true
    }

    override func tapOnSearchButton(_ view: DashboardViewModel) {
        isTapOnSearchButtonCalled = true
    }
}

class DashboardViewControllerTests: XCTestCase {

    var sut: DashboardViewController!
    var mockViewModel: MockDashboardViewModel!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController
        mockViewModel = MockDashboardViewModel()
        sut.dashboardViewModel = mockViewModel
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }

    func testViewDidLoad_CallsFetchNewsData() {
        sut.viewDidLoad()
        XCTAssertTrue(mockViewModel.isGetAllSourcesCalled, "Expected getAllSources to be called")
    }

    func testSearchButtonTapped_CallsTapOnSearchButton() {
        sut.searchButtonTapped()
        XCTAssertTrue(mockViewModel.isTapOnSearchButtonCalled, "Expected tapOnSearchButton to be called")
    }

    func testFetchNewsData_PopulatesGeneralSources() {
        sut.fetchNewsData()
        XCTAssertEqual(sut.generalsources.count, 1)
        XCTAssertEqual(sut.generalsources.first?.name, "Mock Source")
    }

    func testTableView_NumberOfSections_ReturnsFour() {
        let sections = sut.numberOfSections(in: sut.newsTable)
        XCTAssertEqual(sections, 4)
    }

    func testTableView_NumberOfRowsInSection_ReturnsOne() {
        let rows = sut.tableView(sut.newsTable, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, 1)
    }

    func testTableView_CellForRowAt_ReturnsConfiguredCell() {
        sut.fetchNewsData()
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(sut.newsTable, cellForRowAt: indexPath) as? DashboardTableViewCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.newsType, .source)
    }

    func testTableView_HeightForRowAt_ReturnsCorrectHeight() {
        let indexPath = IndexPath(row: 0, section: 0)
        let height = sut.tableView(sut.newsTable, heightForRowAt: indexPath)
        XCTAssertEqual(height, 150)
    }

    func testTableView_TitleForHeaderInSection_ReturnsCorrectTitle() {
        let title = sut.tableView(sut.newsTable, titleForHeaderInSection: 0)
        XCTAssertEqual(title, NewsSections.generalSource.rawValue)
    }

    func testDidTapOnSourceItem_CallsTapOnSourceItem() {
        sut.didTaponSourceItem(index: 0, source: "Source")
        XCTAssertTrue(mockViewModel.isTapOnSourceItemCalled, "Expected tapOnSourceItem to be called")
    }
}
