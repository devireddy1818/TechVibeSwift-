//
//  DashboardViewModel.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import UIKit
enum NewsType {
    case headline
    case source
}

enum NewsSections: String {
    case generalSource = "General Source"
    case businessSource = "Business Source"
    case topIndiaHeadLines = "Top India Head-lines"
    case topUSHeadLines = "Top US Head-lines"

}
protocol DashboardViewModelDelegate: AnyObject {
    func didTapOnSourceItem(item: Int?, source: String?, view: DashboardViewModel)
    func didTapOnSearchButton(_ view: DashboardViewModel)

}

class DashboardViewModel: BaseViewModel {
    weak var delegate: DashboardViewModelDelegate?
    var networkManager = AlamofireNetworkAdapter.shared
    var responseSuccessHandler:( _ isSuccess: Bool, _ message: String)->() = {_,_ in}
    
    func getAllSources(category: String? = nil, completion: @escaping ([Source])-> Void) {
        var urlString = URLS.baseURL + URLS.newsSources
        if category?.isEmpty == false {
            urlString += "category=\(category ?? "")"
        }
        urlString += "&apiKey=\(URLS.newsApiKey)"
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.main.async {
            self.startIndicatorHandler()
        }
        self.networkManager.request(url, method: HTTPMethods.get.rawValue, parameters: nil, headers: nil) { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorHandler()
            }
            switch result {
            case .success(let value):
                if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) {
                    do {
                        let sourceModel = try JSONDecoder().decode(SourceModel.self, from: jsonData)
                        if let status = sourceModel.status, status == "ok", let sources = sourceModel.sources, sources.isEmpty == false {
                            completion(sourceModel.sources ?? [])
                            self.responseSuccessHandler(true, status)
                        } else {
                            completion([])
                        }
                    } catch (let error) {
                        self.responseSuccessHandler(false, error.localizedDescription)
                    }
                } else {
                    self.responseSuccessHandler(false, "Failed to serialize JSON")
                }
                
            case .error (let error):
                self.responseSuccessHandler(false, error.description)
                
            }
        }
    }
    
    func getTopHeadlines(country: String? = nil,category: String? = nil, completion: @escaping ([Article])-> Void) {
        var urlString = URLS.baseURL + URLS.topHeadlines
        if country?.isEmpty == false {
            urlString += "country=\(country ?? "")"
        }
        if category?.isEmpty == false {
            urlString += "&category=\(category ?? "")"
        }
        urlString += "&apiKey=\(URLS.newsApiKey)"
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.main.async {
            self.startIndicatorHandler()
        }
        self.networkManager.request(url, method: HTTPMethods.get.rawValue, parameters: nil, headers: nil) { (result) in
            DispatchQueue.main.async {
                self.stopIndicatorHandler()
            }
            switch result {
            case .success(let value):
                if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) {
                    do {
                        let topHeadlinesModel = try JSONDecoder().decode(TopHeadlinesModel.self, from: jsonData)
                        if let status = topHeadlinesModel.status, status == "ok", let articles = topHeadlinesModel.articles, articles.isEmpty == false {
                            completion(topHeadlinesModel.articles ?? [])
                            self.responseSuccessHandler(true, status)
                        } else {
                            completion([])
                        }
                    } catch (let error) {
                        self.responseSuccessHandler(false, error.localizedDescription)
                    }
                } else {
                    self.responseSuccessHandler(false, "Failed to serialize JSON")
                }
                
            case .error (let error):
                self.responseSuccessHandler(false, error.description)
                
            }
        }
    }
    
    func tapOnSourceItem(item: Int?, source: String?) {
        self.delegate?.didTapOnSourceItem(item: item, source: source, view: self)
    }
    
    func tapOnSearchButton(_ view: DashboardViewModel) {
        self.delegate?.didTapOnSearchButton(view)
    }
}
