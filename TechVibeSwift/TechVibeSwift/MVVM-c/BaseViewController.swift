//
//  ViewController.swift
//  Vendor
//
//  Created by devireddy k on 21/08/24.
//

import UIKit

@IBDesignable extension UIView {
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}
@IBDesignable
extension UITextField {
    
    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}

typealias AlertHandler = (_ alertAction:UIAlertAction) -> ()
class BaseViewController: UIViewController, StoryBoard {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    lazy var activityIndicagtorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicatorView.style = UIActivityIndicatorView.Style.large
        activityIndicatorView.color = UIColor.systemBlue
        return activityIndicatorView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
            // Fallback on earlier versions
        }
    }
    
    func startIndicator() {
        self.view.addSubview(activityIndicagtorView)
        activityIndicagtorView.startAnimating()
        self.view.isUserInteractionEnabled = false
        
    }
    
    func stopIndicator() {
        activityIndicagtorView.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func displayAlert(title: String = "OOPS",message: String, handlerAction:AlertHandler? = nil)  {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: handlerAction)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion:{
            alertController.view.superview?.subviews.first?.isUserInteractionEnabled = true
            alertController.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
        
    }
    
    func displayAlert(title: String = "Alert",message: String, alertTitles: [String], handlerAction:[AlertHandler])  {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (key, value) in alertTitles.enumerated() {
            let alertAction = UIAlertAction(title: value, style: .default, handler: handlerAction[key])
            alertController.addAction(alertAction)
        }
        self.present(alertController, animated: true, completion:{
            alertController.view.superview?.subviews.first?.isUserInteractionEnabled = true
            alertController.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })    }
    
    
    func displayAlertActionSheet(title: String = "Alert",message: String, alertTitles: [String], handlerAction:[AlertHandler])  {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for (key, value) in alertTitles.enumerated() {
            let alertAction = UIAlertAction(title: value, style: .default, handler: handlerAction[key])
            alertController.addAction(alertAction)
        }
        alertController.view.tintColor = .darkGray
        self.present(alertController, animated: true, completion:{
            alertController.view.superview?.subviews.first?.isUserInteractionEnabled = true
            alertController.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
        
    }
    
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIViewController {
    func showToast(message : String) {
        let messageLbl = UILabel()
        messageLbl.text = message
        messageLbl.textAlignment = .center
        messageLbl.font = UIFont.systemFont(ofSize: 12)
        messageLbl.textColor = .white
        messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let textSize:CGSize = messageLbl.intrinsicContentSize
        let labelWidth = min(textSize.width, self.view.frame.width - 40)
        
        messageLbl.frame = CGRect(x: 20, y: self.view.frame.height - 90, width: labelWidth + 30, height: textSize.height + 20)
        messageLbl.center.x = self.view.center.x
        messageLbl.layer.cornerRadius = messageLbl.frame.height/2
        messageLbl.layer.masksToBounds = true
        self.view.addSubview(messageLbl)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            UIView.animate(withDuration: 1, animations: {
                messageLbl.alpha = 0
            }) { (_) in
                messageLbl.removeFromSuperview()
            }
        }
    }}
