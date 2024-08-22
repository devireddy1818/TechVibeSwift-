//
//  SearchCoordinator.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import UIKit
protocol SearchCoordinatorDelegate: AnyObject {
    
}
class SearchCoordinator: Coordinator {
    weak var delegate: SearchCoordinatorDelegate?
    var dashboardViewModel: DashboardViewModel?
    var source: String?
    var navigationController: UINavigationController
    init(_ nav: UINavigationController) {
        navigationController = nav
    }
    
    func start() {
        let searchViewController = SearchViewController.instantiate(StoryBoardName.main)
        let searchViewModel = SearchViewModel()
        searchViewModel.delegate = self
        searchViewController.dashboardViewModel = dashboardViewModel
        searchViewController.searchViewModel = searchViewModel
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(searchViewController, animated: false)
    }
}

extension SearchCoordinator: SearchViewModelDelegate {
    
}
