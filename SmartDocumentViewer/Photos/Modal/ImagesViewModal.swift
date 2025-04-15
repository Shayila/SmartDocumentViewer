//
//  ImagesViewModal.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 15/04/25.
//

import Foundation

class ImagesViewModal {
    
    var imagesArray = [ImageTable]()
    
    static func insertPhotoList(name : String,location: String) {
        CoreDataManager.shared.savePhoto(name: name, id: Constant.getTimeStamp(), location: location)
    }
    
    
    func fetchImageList(){
        imagesArray = CoreDataManager.shared.fetchImageList()
    }
    
    
    func deleteImg(name : String) {
        CoreDataManager.shared.deleteImgDetail(name: name)
    }
}


