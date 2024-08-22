//
//  WebViewControllerTests.swift
//  TechVibeSwiftTests
//
//  Created by devireddy k on 22/08/24.
//

import XCTest
import WebKit
@testable import TechVibeSwift

class WebViewControllerTests: XCTestCase {
    var webViewController: WebViewController!
    var mockWebView: WKWebView!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        webViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
        webViewController.loadViewIfNeeded()
        mockWebView = WKWebView()
        webViewController.webView = mockWebView
        mockWebView.navigationDelegate = webViewController
    }
    
    func testWebViewLoading() {
        let mockURL = "https://google.com/"
        webViewController.source = mockURL
        webViewController.viewDidLoad()
        XCTAssertNotNil(webViewController.webView)
        XCTAssertEqual(webViewController.webView.url?.absoluteString, mockURL)
    }
}
