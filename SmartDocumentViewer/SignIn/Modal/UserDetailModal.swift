//
//  UserDetailModal.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 14/04/25.
//

import Foundation


class UserDetailViewModal {
    
    var name = ""
    var email = ""
    var imageURL = ""
    
    
    init() {
    
    }
    
    init(user : UserDetails) {
        self.email = user.email!
        self.imageURL = user.imageURL!
        self.name = user.name!
    }
}
