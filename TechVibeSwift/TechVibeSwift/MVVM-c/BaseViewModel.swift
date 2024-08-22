import Foundation
class BaseViewModel {
    var stopIndicatorHandler:() -> () = {}
    var startIndicatorHandler:() -> () = {}
}
