
//  ImagePickerManager.swift
//  Cities
//  Created by CHEMAC007 on 14/07/21.

import UIKit
import UniformTypeIdentifiers
import MobileCoreServices
import PhotosUI

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentPickerDelegate {
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
    var viewController: UIViewController?
    var pickImageCallback : ((Data,String, Bool) -> ())?;
    var pickMultipleImagesCallback : (([Data],[String],[Int], Bool) -> ())?;
    var pickImageWithFileSizeCallback : ((Data,String,Int,Bool) -> ())?;
    var fileOption = true
    var isFromSpaceAndPulse = false
    var imageSelectionLimit = 10
    override init() {        
        super.init()
    }
    
    
    func pickImagefromCamera(_ viewController: UIViewController, _ callback: @escaping ((Data,String, Bool) -> ())) {
        
        pickImageCallback = callback;
        self.viewController = viewController;
        self.pickAssetsFor(isToShowAlert: false)
        self.openCamera()
    }
    
    
    func pickImageAlone(_ viewController: UIViewController, _ callback: @escaping ((Data,String, Bool) -> ())) {
        
        fileOption = false
        pickImageCallback = callback;
        self.viewController = viewController;
        self.pickAssetsFor(galleryAcess: true, cameraAccess: true)
    }
    
    
    func pickAssetsFor(fileAccess : Bool? = nil,galleryAcess : Bool? = nil,cameraAccess : Bool? = nil, multipleImageAccess  : Bool? = nil, imageSelectionLimit : Int? = nil, isToShowAlert : Bool? = true,isNeededCancel : Bool? = nil){
        
        if let cameraAccess = cameraAccess,cameraAccess {
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        alert.addAction(cameraAction)
        }
        
        if let galleryAcess = galleryAcess, galleryAcess{
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        alert.addAction(galleryAction)
        }
        
        if let multipleImageAccess = multipleImageAccess,multipleImageAccess {
            
            let galleryAction = UIAlertAction(title: "Gallery", style: .default){
                UIAlertAction in
                self.openGallery()
            }
            self.imageSelectionLimit = multipleImageAccess ? (imageSelectionLimit ?? 0) : 0
            alert.addAction(galleryAction)
        }
        if fileAccess == false {

        } else {
            if let fileAccess = fileAccess,fileAccess {
            let fileAction = UIAlertAction(title: "File", style: .default){
                UIAlertAction in
                //self.openFile()
            }
            alert.addAction(fileAction)
            }
        }
        
        if isNeededCancel == false {
            
        } else {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                UIAlertAction in
                if let pickImageWithFileSizeCallback = self.pickImageWithFileSizeCallback {
                    pickImageWithFileSizeCallback(Data(),"",0,false)
                }
                self.pickImageCallback?(Data(),"",false)
            }
            alert.addAction(cancelAction)
        }
        // Add the actions
        picker.delegate = self
        
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        if let isToShowAlert = isToShowAlert, isToShowAlert {
            viewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
            }()
            viewController?.present(alertController, animated: true)
        }
    }
    
    
    func openGallery() {
        if isFromSpaceAndPulse {
            if #available(iOS 14.0, *) {
            var config = PHPickerConfiguration()
            config.selectionLimit = imageSelectionLimit
            config.filter = PHPickerFilter.images
            let pickerController = PHPickerViewController(configuration: config)
            pickerController.delegate = self
            self.viewController!.present(pickerController, animated: true)
            }
            else {
                alert.dismiss(animated: true, completion: nil)
                picker.sourceType = .photoLibrary
                self.viewController!.present(picker, animated: true, completion: nil)
            }
        }
        else{
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let pickMultipleImagesCallback = pickMultipleImagesCallback {
            pickMultipleImagesCallback([Data()],[""],[0], false)
        }
        else if let pickImageWithFileSizeCallback = pickImageWithFileSizeCallback {
            pickImageWithFileSizeCallback(Data(),"",0,false)
        }
        else {
            pickImageCallback?(Data(),"",false)
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        if let data = image.jpegData(compressionQuality: 1.0) {
            if let pickMultipleImagesCallback = pickMultipleImagesCallback {
                pickMultipleImagesCallback([data],["jpeg"],[data.count], true)
            }
            else if let pickImageWithFileSizeCallback = pickImageWithFileSizeCallback {
                pickImageWithFileSizeCallback(data,"jpeg",data.count,true)
            }
            else {
                pickImageCallback?(data,"jpeg",true)
            }
        }
        else{
            if let pickMultipleImagesCallback = pickMultipleImagesCallback {
                pickMultipleImagesCallback([Data()],[""],[0], false)
            }
            else if let pickImageWithFileSizeCallback = pickImageWithFileSizeCallback {
                pickImageWithFileSizeCallback(Data(),"",0,true)
            }
            else {
                pickImageCallback?(Data(),"",false)
            }
        }
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
        
    }
    
    
}

extension ImagePickerManager: PHPickerViewControllerDelegate {
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        let imageItems = results .map { $0.itemProvider } .filter { $0.canLoadObject(ofClass: UIImage.self) }
        let dispatchGroup = DispatchGroup()
        var multipleImages = [Data]()
        var multipleFormate = [String]()
        var fileSizes = [Int]()
        for imageItem in imageItems {
            dispatchGroup.enter() // signal IN
            imageItem.loadObject(ofClass: UIImage.self) { image, error in
                debugPrint("Error : \(error.debugDescription)")
                if let image = image as? UIImage
                {
                    if let data = image.jpegData(compressionQuality: 1.0) {
                        let size = data.count
                        fileSizes.append(size)
                        multipleImages.append(data)
                        multipleFormate.append("jpeg")
                    }
                    else{
                        self.pickMultipleImagesCallback?([Data](),[""],[0],false)
                    }
                }
                else {
                    self.pickMultipleImagesCallback?([Data](),[""],[0],false)
                }
                dispatchGroup.leave() // signal OUT
            }
        }
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.pickMultipleImagesCallback?(multipleImages,multipleFormate,fileSizes,true)
            }
        }
    }
    
    
    @available(iOS 14, *)
    func pickerController(_ controller: PHPickerViewController, didSelect images: [UIImage]?) {
        
        controller.dismiss(animated: true, completion: nil)
        if(images!.count > 0) {
            for img in images!{
                print(img)
            }
        }
    }
    
    
    
    
}
