//
//  CoreDataManager.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 14/04/25.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var moc: NSManagedObjectContext
    
    private init() {
        self.moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = PersistenceController.shared.container.persistentStoreCoordinator
    }
    
    
}

//MARK: - User Details Table
extension CoreDataManager {
    
    
    func saveUserDetails(name : String, email : String, imgURL : String) {
        
        let userDetail = UserDetails(context: self.moc)
        userDetail.email = email
        userDetail.imageURL = imgURL
        userDetail.name = name
        
        do {
            try self.moc.save()
        }
        catch {
            print(error)
        }
    }
    
    
    
    func fetchUserDetail(email : String) -> UserDetails? {
        
        
        let request : NSFetchRequest<UserDetails> = UserDetails.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            return  try self.moc.fetch(request).first
        }
        catch {
            print(error)
        }
        
        return nil
    }
    
    
    func deleteUserDetail(email : String) {
        do {
            if let user = fetchUserDetail(email: email) {
                
                self.moc.delete(user)
                try self.moc.save()
            }
        }
        catch {
            print(error)
        }
    }
}
