import UIKit

enum CoordinatorNames: String {
    case Dashboard = "Dashboard"
    case Login = "Search"
    case Profile = "Web"
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController = UINavigationController()
    
    func start() {
        showDashboardScreen()
    }
    lazy var viewnavigator: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
        
    }()
    lazy var loginNavigator: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
        
    }()
    var window: UIWindow?
    
    lazy var homeNavigator: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    var childCoordinators = [CoordinatorNames: Coordinator]()
    init(window:UIWindow?) {
        self.window = window
        //NotificationCenter.default.addObserver(self, selector: #selector(handlesessionExpired(_:)), name: NSNotification.Name.sessionExpired, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func configureRootViewController(_ vc: UINavigationController) {
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
}

extension AppCoordinator: DashboardCoordinatorDelegate {
    
    func showDashboardScreen() {
        configureRootViewController(homeNavigator)
        let dashboardCoordinator = DashboardCoordinator(homeNavigator)
        dashboardCoordinator.delegate = self
        dashboardCoordinator.start()
        childCoordinators[CoordinatorNames.Dashboard] =  dashboardCoordinator
    }
}
extension Notification.Name {
    
    static let sessionExpired = Notification.Name("sessionExpired")
}
