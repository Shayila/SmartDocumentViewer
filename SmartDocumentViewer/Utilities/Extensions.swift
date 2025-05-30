//
//  Extensions.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 11/04/25.
//

import Foundation
import UIKit
import AlamofireImage



// MARK: - UIView

@IBDesignable

extension UIView {
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor(red: 0.587, green: 0.802, blue: 1, alpha: 0.19).cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 4.0),
                   shadowOpacity: Float = 1,
                   shadowRadius: CGFloat = 4.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    @IBInspectable var borderWidths: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColors: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
                    
}


extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


// MARK: - UIImageview
extension UIImageView {
    
    func setImage (_ urlString : String, _ placeHolder : String){
        let urlStrin = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString
        if let url = URL (string: urlStrin){
            //Placeholder Image which was in your Local(Assets)
            let image = UIImage (named: placeHolder)
            self.image = image
            ImageResponseSerializer.addAcceptableImageContentTypes(["image/jpg","image/png","binary/octet-stream"])
            self.af.setImage(withURL: url)
        }
        else
        {
            self.image = UIImage(named: placeHolder)
        }
    }
}
