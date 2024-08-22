//
//  DashboardViewController.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import UIKit

class DashboardViewController: BaseViewController {
    @IBOutlet weak var newsTable: UITableView!
    var dashboardViewModel: DashboardViewModel?
    var generalsources: [Source] = []
    var businesSources: [Source] = []
    var indiaArticles: [Article] = []
    var usArticles: [Article] = []
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpNaviagtionBar()
        self.setupRefreshControl()
        self.setupDashBoardViewModel()
        self.fetchNewsData()
    }
    
    func setUpNaviagtionBar() {
        self.navigationItem.title = "News Feed"
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchButtonTapped))
        self.navigationItem.rightBarButtonItem = searchButton
    }
    @objc
    func searchButtonTapped() {
        if let dashboardViewModel = self.dashboardViewModel {
            self.dashboardViewModel?.tapOnSearchButton(dashboardViewModel)
        }
    }
    
    func fetchNewsData() {
        self.dashboardViewModel?.getAllSources() { [weak self] sources in
            self?.generalsources = sources
            self?.reloadNewsTableView(section: 0)
            self?.dashboardViewModel?.getAllSources(category: "business") { [weak self] sources in
                self?.businesSources = sources
                self?.reloadNewsTableView(section: 1)
                self?.dashboardViewModel?.getTopHeadlines(country: "in"){ [weak self] articles in
                    self?.indiaArticles = articles
                    self?.reloadNewsTableView(section: 2)
                    self?.dashboardViewModel?.getTopHeadlines(country: "us"){ [weak self] articles in
                        self?.usArticles = articles
                        self?.reloadNewsTableView(section: 3)
                    }
                }
            }
        }
    }
    
    func reloadNewsTableView(section: Int) {
        self.newsTable.beginUpdates()
        let indexSet = IndexSet(integer: section)
        self.newsTable.reloadSections(indexSet, with: .automatic)        
        self.newsTable.endUpdates()
    }
    
    func setupRefreshControl() {
        self.newsTable.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc
    func refreshData(_ sender: Any) {
        self.fetchNewsData()
        self.refreshControl.endRefreshing()
    }
    
    func setupDashBoardViewModel() {
        self.dashboardViewModel?.responseSuccessHandler = {[unowned self] isSuccess, message in
            if !isSuccess {
                self.showToast(message: message)
            }
        }
        self.dashboardViewModel?.startIndicatorHandler = { [weak self] in
            self?.startIndicator()
        }
        self.dashboardViewModel?.stopIndicatorHandler = { [weak self] in
            self?.stopIndicator()
        }
    }
    
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell") as? DashboardTableViewCell
        cell?.delegate = self
        switch indexPath.section {
        case 0:
            cell?.newsType = .source
            cell?.configure(with: self.generalsources)
        case 1:
            cell?.newsType = .source
            cell?.configure(with: self.businesSources)
        case 2:
            cell?.newsType = .headline
            cell?.configure(with: self.indiaArticles)
        case 3:
            cell?.newsType = .headline
            cell?.configure(with: self.usArticles)
        default: return cell ?? UITableViewCell()
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NewsSections.generalSource.rawValue
        case 1:
            return NewsSections.businessSource.rawValue
        case 2:
            return NewsSections.topIndiaHeadLines.rawValue
        case 3:
            return NewsSections.topUSHeadLines.rawValue
        default:
            return ""
        }
    }
    
}

extension DashboardViewController: DashboardDashboardTableViewCellDelegate {
    func didTaponSourceItem(index: Int?, source: String?) {
        self.dashboardViewModel?.tapOnSourceItem(item: index, source: source)
    }
}
