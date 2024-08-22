//
//  DashboardCoordinator.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import UIKit
protocol DashboardCoordinatorDelegate: AnyObject {
    
}
class DashboardCoordinator: Coordinator {
    weak var delegate: DashboardCoordinatorDelegate?
    var webCoordinator: WebCoordinator?
    var searchCoordinator: SearchCoordinator?

    var navigationController: UINavigationController
    init(_ nav: UINavigationController) {
        navigationController = nav
    }
    
    func start() {
        let dashboardViewController = DashboardViewController.instantiate(StoryBoardName.main)
        let dashboardViewModel = DashboardViewModel()
        dashboardViewModel.delegate = self
        dashboardViewController.dashboardViewModel = dashboardViewModel
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(dashboardViewController, animated: false)
    }
}

extension DashboardCoordinator: DashboardViewModelDelegate {
    func didTapOnSearchButton(_ view: DashboardViewModel) {
        searchCoordinator = SearchCoordinator(navigationController)
        searchCoordinator?.delegate = self
        searchCoordinator?.dashboardViewModel = view
        searchCoordinator?.start()
    }
    
    func didTapOnSourceItem(item: Int?, source: String?, view: DashboardViewModel) {
        webCoordinator = WebCoordinator(navigationController)
        webCoordinator?.source = source
        webCoordinator?.delegate = self
        webCoordinator?.start()
    }
}

extension DashboardCoordinator: WebCoordinatorDelegate {
    
}
extension DashboardCoordinator: SearchCoordinatorDelegate {
    
}
