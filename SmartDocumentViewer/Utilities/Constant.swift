//
//  Constant.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 14/04/25.
//

import Foundation
import UIKit
import GoogleSignIn


class Constant {
    
    static var profile : GIDGoogleUser? = nil
    
    
   static func callHomePageVC(){
       
       let storyBoard = UIStoryboard(name: "Main", bundle: nil)
       guard let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomePageID") as? UINavigationController else { return }
       
       let appdelegate = UIApplication.shared.delegate as! AppDelegate
       appdelegate.window!.rootViewController = homeVC
       appdelegate.window!.makeKeyAndVisible()
   }
    
    
    
    static func callLoginPageVC(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewID") as? UINavigationController else { return }
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = homeVC
        appdelegate.window!.makeKeyAndVisible()
    }
    
    
    
    static func openFileViewerVC(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let fileVC = storyBoard.instantiateViewController(withIdentifier: "FileViewerID") as? FileViewerController else { return }
        
        fileVC.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.navigationController?.pushViewController(fileVC, animated: true)
    }
}
