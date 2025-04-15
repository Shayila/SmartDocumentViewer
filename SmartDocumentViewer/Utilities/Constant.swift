//
//  Constant.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 14/04/25.
//

import Foundation
import UIKit
import GoogleSignIn
import Photos


class Constant {
    
   // static var profile : GIDGoogleUser? = nil
    
    
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
    
    
    static func openListViewVC(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let listVC = storyBoard.instantiateViewController(withIdentifier: "ListViewID") as? ListViewController else { return }
        
        listVC.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.navigationController?.pushViewController(listVC, animated: true)
    }
    
    static func openPhotosVC(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let fileVC = storyBoard.instantiateViewController(withIdentifier: "GalleryViewID") as? GalleryViewController else { return }
        
        fileVC.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.navigationController?.pushViewController(fileVC, animated: true)
    }
    
    
    static func getTimeStamp() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyMMddHHmmssSSS"
        dateFormatter.locale = Locale(identifier: "enUSPOSIX")
        let dtStr = dateFormatter.string(from: Date())
        //debugPrint("TS : \(dtStr)")
        return dtStr
    }
    
    
    static func saveImageToDocumentDirectory(image: UIImage) -> String{
        let name = "Img\(getTimeStamp()).jpeg"
        let fileURL = documentImagesDirectory().appendingPathComponent(name)
        if let data = image.jpegData(compressionQuality: 1.0),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
                return name
            } catch {
                print("error saving file:", error)
                return ""
            }
        }
        else{
            return ""
        }
    }
    
    
    static func deleteImageIfExist(imageName: String)  {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "\(documentImagesDirectory().appendingPathComponent(imageName).path)"){
            do{
                try fileManager.removeItem(atPath: "\(documentImagesDirectory().appendingPathComponent(imageName).path)")
                
            }catch{
                
            }
        }
    }
    
    
    static func documentImagesDirectory()-> URL{
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderName = "DocumentImages"
        return documentsDirectory.appendingPathComponent(folderName)
    }
    
    
    static func getGalleryImage(path : String) -> UIImage? {
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: "\(documentImagesDirectory().appendingPathComponent(path).path)"){
            return UIImage(contentsOfFile: documentImagesDirectory().appendingPathComponent(path).path) ?? UIImage()
        }
        else{
            return nil//UIImage()
        }
        
    }
    
    
    static func createGalleryFolder(){
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let docURL = URL(string: documentsDirectory!)
        let dataPath = docURL!.appendingPathComponent("DocumentImages")
        if !FileManager.default.fileExists(atPath: dataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func checkCameraAccess() -> Bool{
        if AVCaptureDevice.authorizationStatus(for: .video) !=  .authorized {
            
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                
                if !granted {
                    //access denied
                    DispatchQueue.main.async {
                        
                        let ac = UIAlertController(title: "Camera Access Denied!", message:"Please go to Settings on your phone, search for 'The Hub' app and enable camera access", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default){ (action) in})
                        UIApplication.topViewController()?.present(ac, animated: true)
                    }
                }
            })
            return false
        }
        else{
            return true
        }
    }
    
    static func checkforLibraryAccess() -> Bool{
        if #available(iOS 14, *) {
            if  PHPhotoLibrary.authorizationStatus(for: .readWrite) == .limited || PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized{
                return true
            }
            else{
                PHPhotoLibrary.requestAuthorization { status in
                    
                    switch status {
                        
                    case .notDetermined:
                        break
                        
                    case .restricted, .denied:
                        let alert = UIAlertController(title:"Photo Access restriced or denied", message:"Please allow access to your photo library", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            alert.dismiss(animated: true)
                        }))
                        DispatchQueue.main.async {
                            UIApplication.topViewController()?.present(alert, animated: true)
                        }
                        break
                        
                    case .authorized:
                        break
                        
                    case .limited:
                        let alert = UIAlertController(title: "Photo Access Limited", message: "Please allow full access to your photo library", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            alert.dismiss(animated: true)
                        }))
                        DispatchQueue.main.async {
                            UIApplication.topViewController()?.present(alert, animated: true)
                        }
                        break
                        
                    default:
                        break
                    }
                }
                return false            }
        }
        else{
            return false
        }
        
    }
    
    
}
