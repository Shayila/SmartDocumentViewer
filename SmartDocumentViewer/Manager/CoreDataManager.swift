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


//MARK: - List Modal
extension CoreDataManager {
    
    func saveList(list : [ListModal]) {
        list.forEach({saveEachRowInListTable(item: $0)})
    }
    
    func saveEachRowInListTable( item : ListModal) {
        var lTable = ListTable(context: self.moc)
        lTable.listId = item.id
        lTable.name = item.name
        
        if let data = item.data{
            let dCTable = DataClassTable(context: self.moc)
            dCTable.foreignID = item.id
            dCTable.capacity = data.capacity ?? ""
            dCTable.capacityGB = Int32(data.capacityGB ?? 0)
            dCTable.caseSize = data.caseSize ?? ""
            dCTable.color = data.color ?? ""
            dCTable.cpuModel = data.cpuModel ?? ""
            dCTable.dataCapacity = data.dataCapacity ?? ""
            dCTable.dataColor = data.dataColor ?? ""
            dCTable.dataGeneration = data.dataGeneration ?? ""
            dCTable.dataPrice = data.dataPrice ?? 0.0
            dCTable.descDetails = data.descDetails ?? ""
            dCTable.generation = data.generation ?? ""
            dCTable.hardDiskSize = data.hardDiskSize ?? ""
            dCTable.price = data.price ?? ""
            dCTable.screenSize = data.screenSize ?? 0.0
            dCTable.strapColour = data.strapColour ?? ""
            dCTable.year = Int32(data.year ?? 0)
            
        }
        
        
        do {
            try self.moc.save()
        }
        catch {
            print(error)
        }
    }
    
    
    func deleteEntireList(entityName : String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
        do {
            try self.moc.execute(deleteRequest)
            try self.moc.save()
        }
        catch {
            print(error)
        }
    }
    
    func fetchList() -> [ListTable]{
        
        var result = [ListTable]()
        let request : NSFetchRequest<ListTable> = ListTable.fetchRequest()
        do {
            result = try self.moc.fetch(request)
        }
        catch {
            print(error)
        }
        
        return result
    }
    
    
    func fetchDataClass(id : String? = nil) -> [DataClassTable] {
        
        let request : NSFetchRequest<DataClassTable> = DataClassTable.fetchRequest()
        if let id = id {
            request.predicate = NSPredicate(format: "foreignID == %@", id)
        }
        
        do {
            return  try self.moc.fetch(request)
        }
        catch {
            print(error)
        }
        
        return [DataClassTable]()
    }
    
}

extension CoreDataManager {
    
    func savePhoto(name : String, id: String,location : String){
        
        let phtoT = ImageTable(context: self.moc)
        phtoT.imgName = name
        phtoT.imgID = id
        phtoT.location = location
        
        do {
            try self.moc.save()
        }
        catch {
            print(error)
        }
    }
    
    
    func fetchImageList() -> [ImageTable]{
        var result = [ImageTable]()
        let request : NSFetchRequest<ImageTable> = ImageTable.fetchRequest()
        do {
            result = try self.moc.fetch(request)
        }
        catch {
            print(error)
        }
        
        return result
    }
    
    
    func fetchImgDetail(name : String) -> ImageTable? {
        
        
        let request : NSFetchRequest<ImageTable> = ImageTable.fetchRequest()
        request.predicate = NSPredicate(format: "imgName == %@", name)
        
        do {
            return  try self.moc.fetch(request).first
        }
        catch {
            print(error)
        }
        
        return nil
    }
    
    
    func deleteImgDetail(name : String) {
        do {
            if let user = fetchImgDetail(name: name) {
                
                self.moc.delete(user)
                try self.moc.save()
            }
        }
        catch {
            print(error)
        }
    }
}
