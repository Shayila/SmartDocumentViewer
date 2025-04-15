//
//  SignInViewModal.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 14/04/25.
//

import Foundation
import UIKit

class SignInViewModal: NSObject {

    var signInDetail = UserDetailViewModal()
    var email : String {
        return UserDefaults.standard.value(forKey: "email") as? String ?? ""
    }
    
    func saveUserDetail(name : String, email : String, imgUrl: String){
        CoreDataManager.shared.deleteUserDetail(email: email)
        CoreDataManager.shared.saveUserDetails(name: name, email: email, imgURL: imgUrl)
    }
    
    func fetchUserDetails() {
        
        if let user = CoreDataManager.shared.fetchUserDetail(email: email).map(UserDetailViewModal.init) {
            signInDetail = user
        }
        
    }
    
    func deleteUserDetail() {
        CoreDataManager.shared.deleteUserDetail(email: email)
    }
    
    
    func deleteEntireEntities(){
        CoreDataManager.shared.deleteEntireList(entityName: "DataClassTable")
        CoreDataManager.shared.deleteEntireList(entityName: "ListTable")
        CoreDataManager.shared.deleteEntireList(entityName: "UserDetails")
    }
}
