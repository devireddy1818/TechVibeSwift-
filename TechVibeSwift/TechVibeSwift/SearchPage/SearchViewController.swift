//
//  SearchViewController.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import UIKit

class SearchViewController: BaseViewController {
    var searchViewModel: SearchViewModel?
    var dashboardViewModel: DashboardViewModel?
    @IBOutlet weak var searchTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var articles: [Article] = []    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        self.setupSearchController()
        self.setupSearchViewModel()
        self.fetchAllNews()
        self.setupRefreshControl()
    }
    
    func setupRefreshControl() {
        self.searchTableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc
    func refreshData(_ sender: Any) {
        self.fetchAllNews()
        self.refreshControl.endRefreshing()
    }
    func setupSearchViewModel() {
        self.searchViewModel?.responseSuccessHandler = {[unowned self] isSuccess, message in
            if !isSuccess {
                self.showToast(message: message)
            }
        }
        self.searchViewModel?.startIndicatorHandler = { [weak self] in
            self?.startIndicator()
        }
        self.searchViewModel?.stopIndicatorHandler = { [weak self] in
            self?.stopIndicator()
        }
    }
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search news"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }
    
    func fetchAllNews(searchText: String = "Popular") {
        self.searchViewModel?.getAllNews(searchText: searchText, fromDate: self.searchViewModel?.getYesterdayDate(), sortBy: "popularity") { [weak self] articles in
            self?.articles = articles
            self?.searchTableView.reloadData()
        }
    }
}
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        let article = self.articles[indexPath.row]
        cell.searchViewModel = searchViewModel
        cell.configure(with: article)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dashboardViewModel?.tapOnSourceItem(item: indexPath.row, source: self.articles[indexPath.row].url ?? "")
    }
}

extension SearchViewController:  UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        self.fetchAllNews(searchText: searchText)
    }
}
