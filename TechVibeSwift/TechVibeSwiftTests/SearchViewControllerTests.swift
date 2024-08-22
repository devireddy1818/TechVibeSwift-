//
//  SearchViewControllerTests.swift
//  TechVibeSwiftTests
//
//  Created by devireddy k on 22/08/24.
//

import XCTest
@testable import TechVibeSwift

class SearchViewControllerTests: XCTestCase {
    var searchViewController: SearchViewController!
    var mockSearchViewModel: MockSearchViewModel!
    var mockDashboardViewModel: MockSearchBoardViewModel!
    let mockArticles = [Article(
        author: "Sita Neupane",
        content: """
        KATHMANDU: Social media has become a popular platform for advertising almost everything,
        including job opportunities. Many people looking for employment turn to these platforms
        in their search. Recently, there has been a surge in advertisements for online job scams.
        """,
        description: """
        KATHMANDU: Social media has become a popular platform for advertising almost everything,
        including job opportunities. Many people looking for employment turn to these platforms
        in their search. Recently, there has been a surge in advertisements for online job scams.
        """,
        publishedAt: "2024-08-21T00:15:35Z",
        source: nil,
        title: "How people fall victim to online job scam",
        url: "https://english.khabarhub.com/2024/21/386416/",
        urlToImage: "https://english.khabarhub.com/wp-content/uploads/2024/08/Digital_Platform-Online.jpg")]
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        searchViewController.loadViewIfNeeded()
        mockSearchViewModel = MockSearchViewModel()
        searchViewController.searchViewModel = mockSearchViewModel
        mockDashboardViewModel = MockSearchBoardViewModel()
        searchViewController.dashboardViewModel = mockDashboardViewModel
        searchViewController.searchTableView.dataSource = searchViewController
        searchViewController.searchTableView.delegate = searchViewController
    }
    
    func testFetchAllNewsCallsGetAllNews() {
        searchViewController.fetchAllNews(searchText: "Test")
        XCTAssertTrue(mockSearchViewModel.getAllNewsCalled)
    }
    
    func testSetupSearchController() {
        searchViewController.setupSearchController()
        XCTAssertEqual(searchViewController.searchController.searchBar.placeholder, "Search news")
        XCTAssertNotNil(searchViewController.searchController.searchResultsUpdater)
        XCTAssertNotNil(searchViewController.navigationItem.searchController)
    }
    
    func testNumberOfRowsInSection() {
        searchViewController.articles = self.mockArticles
        let rows = searchViewController.tableView(searchViewController.searchTableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, 1)
    }
    
    func testCellForRowAt() {
        let mockArticle = Article(author: "Author", content: "Content", description: "Description", publishedAt: "2024-08-22T00:00:00Z", source: nil, title: "Title", url: "http://example.com", urlToImage: "http://example.com/image.jpg")
        searchViewController.articles = [mockArticle]
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = searchViewController.tableView(searchViewController.searchTableView, cellForRowAt: indexPath) as! SearchTableViewCell
        XCTAssertEqual(cell.selectionStyle, .none)
    }
    
    func testDidSelectRowAt() {
        let mockArticle = Article(author: "Author", content: "Content", description: "Description", publishedAt: "2024-08-22T00:00:00Z", source: nil, title: "Title", url: "http://example.com", urlToImage: "http://example.com/image.jpg")
        searchViewController.articles = [mockArticle]
        let indexPath = IndexPath(row: 0, section: 0)
        searchViewController.tableView(searchViewController.searchTableView, didSelectRowAt: indexPath)
        XCTAssertTrue(mockDashboardViewModel.tapOnSourceItemCalled)
        XCTAssertEqual(mockDashboardViewModel.selectedItemIndex, 0)
        XCTAssertEqual(mockDashboardViewModel.selectedSource, mockArticle.url)
    }
    
    func testSearchBarSearchButtonClicked() {
        let searchBar = UISearchBar()
        searchBar.text = "Test"
        searchViewController.searchBarSearchButtonClicked(searchBar)
        
        XCTAssertTrue(mockSearchViewModel.getAllNewsCalled)
    }
}

class MockSearchViewModel: SearchViewModel {
    var getAllNewsCalled = false
    
    override func getAllNews(searchText: String?, fromDate: String?, sortBy: String?, completion: @escaping ([Article]) -> Void) {
        getAllNewsCalled = true
        completion([])
    }
}

// Mock DashboardViewModel
class MockSearchBoardViewModel: DashboardViewModel {
    var tapOnSourceItemCalled = false
    var selectedItemIndex: Int?
    var selectedSource: String?
    
    override func tapOnSourceItem(item: Int?, source: String?) {
        tapOnSourceItemCalled = true
        selectedItemIndex = item
        selectedSource = source
    }
}
