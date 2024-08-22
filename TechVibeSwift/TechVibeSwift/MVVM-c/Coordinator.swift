
import UIKit

protocol Coordinator {
    func start()
    var navigationController: UINavigationController { get set}
}

enum StoryBoardName: String {
    case main = "Main"

    
}
protocol  StoryBoard {
    static func instantiate(_ storyBoardName: StoryBoardName) -> Self
}

extension StoryBoard where Self: UIViewController {
    static func instantiate(_ storyBoardName: StoryBoardName) -> Self {
        let id = String(describing: self)
        let storyBoard = UIStoryboard(name: storyBoardName.rawValue, bundle: Bundle.main)
        if #available(iOS 13.0, *) {
            return storyBoard.instantiateViewController(withIdentifier: id) as! Self
        } else {
            return storyBoard.instantiateViewController(withIdentifier: id) as! Self
        }
    }
}
