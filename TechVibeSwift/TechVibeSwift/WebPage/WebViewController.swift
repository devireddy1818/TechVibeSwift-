//
//  WebViewController.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {
    var webViewModel: WebViewModel?
    var source: String?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = URL(string: self.source ?? "") {
            let urlRequest = URLRequest(url: url)
            self.webView.navigationDelegate = self
            self.webView.load(urlRequest)
            DispatchQueue.main.async {
                self.startIndicator()
            }
        }
    }
}
extension WebViewController: WKNavigationDelegate {
    // MARK: - WKNavigationDelegate Methods
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.startIndicator()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.stopIndicator()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.stopIndicator()
        }
    }
}
