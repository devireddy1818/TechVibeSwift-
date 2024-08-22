//
//  SearchViewModelTests.swift
//  TechVibeSwiftTests
//
//  Created by devireddy k on 22/08/24.
//

import XCTest
@testable import TechVibeSwift

class SearchViewModelTests: XCTestCase {
    var searchViewModel: SearchViewModel!

    override func setUp() {
        super.setUp()
        searchViewModel = SearchViewModel()
    }

    override func tearDown() {
        searchViewModel = nil
        super.tearDown()
    }
    
    func testDownloadImageSuccess() {
        let expectation = self.expectation(description: "Image download")
        let imageURL = URL(string: "https://media.wired.com/photos/66bbdd9fa7d637d5d29ecfa5/191:100/w_1280,c_limit/ChatGPT__AdvancedVoiceMode_K86E9P.jpg")!
        searchViewModel.downloadImage(from: imageURL) { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testDownloadImageFailure() {
        let expectation = self.expectation(description: "Image download")
        let imageURL = URL(string: "http://example.com/image.jpg")!
        searchViewModel.downloadImage(from: imageURL) { image in
            XCTAssertNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testGetYesterdayDate() {
        let yesterday = searchViewModel.getYesterdayDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let expectedDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        XCTAssertEqual(yesterday, expectedDate)
    }
}


