//
//  WebCoordinator.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import UIKit
protocol WebCoordinatorDelegate: AnyObject {
    
}
class WebCoordinator: Coordinator {
    weak var delegate: WebCoordinatorDelegate?
    var source: String?
    var navigationController: UINavigationController
    init(_ nav: UINavigationController) {
        navigationController = nav
    }
    
    func start() {
        let webViewController = WebViewController.instantiate(StoryBoardName.main)
        let webViewModel = WebViewModel()
        webViewModel.delegate = self
        webViewController.webViewModel = webViewModel
        webViewController.source = source
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(webViewController, animated: false)
    }
}

extension WebCoordinator: WebViewModelDelegate {
    
}
