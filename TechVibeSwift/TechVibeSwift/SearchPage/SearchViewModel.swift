//
//  SearchViewModel.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import UIKit
protocol SearchViewModelDelegate: AnyObject {
    
}

class SearchViewModel: BaseViewModel {
    weak var delegate: SearchViewModelDelegate?
    var networkManager = AlamofireNetworkAdapter.shared
    var responseSuccessHandler:( _ isSuccess: Bool, _ message: String)->() = {_,_ in}
    func getAllNews(searchText: String? = nil, fromDate: String? = nil, sortBy: String? = nil, completion: @escaping ([Article])-> Void) {
        var urlString = URLS.baseURL + URLS.newsApi
        if searchText?.isEmpty == false {
            urlString += "q=\(searchText ?? "")"
        }
        if fromDate?.isEmpty == false {
            urlString += "&from=\(fromDate ?? "")"
        }
        if sortBy?.isEmpty == false {
            urlString += "&sortBy=\(sortBy ?? "")"
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
                        let sourceModel = try JSONDecoder().decode(TopHeadlinesModel.self, from: jsonData)
                        if let status = sourceModel.status, status == "ok", let sources = sourceModel.articles, sources.isEmpty == false {
                            completion(sourceModel.articles ?? [])
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
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
        task.resume()
    }
    
    func getYesterdayDate() -> String {
        let currentDate = Date()
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let yesterdayDateString = dateFormatter.string(from: yesterdayDate ?? currentDate)
        return yesterdayDateString
    }
}
