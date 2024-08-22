//
//  WebViewModel.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import UIKit
protocol WebViewModelDelegate: AnyObject {
    
}
class WebViewModel: BaseViewModel {
    weak var delegate: WebViewModelDelegate?

}
