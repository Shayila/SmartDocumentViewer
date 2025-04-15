//
//  GalleryViewController.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 15/04/25.
//

import UIKit
import PhotosUI

class GalleryViewController: UIViewController {

    @IBOutlet weak var PhotoBtn: UIButton!
    @IBOutlet weak var photosCollectionV: UICollectionView!
    
    
    var imagesVM : ImagesViewModal {
       let omg = ImagesViewModal()
        omg.fetchImageList()
        return omg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        photosCollectionV.register(UINib(nibName: "GalleryViewCell", bundle: nil), forCellWithReuseIdentifier: GalleryViewCell.reuseId)
        // Do any additional setup after loading the view.
    }
    

    
    func reloadPhotoSection() {
        self.imagesVM.fetchImageList()
        
        photosCollectionV.reloadData()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imagesVM.imagesArray.count//imagePickArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryViewCell.reuseId, for: indexPath) as? GalleryViewCell else {
            return UICollectionViewCell()
        }
        cell.configPhoto = self.imagesVM.imagesArray[indexPath.row].location
        //cell.imageView.image = imagePickArray[indexPath.row].image
        cell.btnClose.setTitle("", for: .normal)
        cell.btnClose.tag = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(deletePhoto(sender:)), for: .touchUpInside)
        cell.btnClose.isHidden = false
            
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryViewCell.reuseId, for: indexPath)
        return CGSize(width: self.photosCollectionV.frame.width / 3 - 20, height: cell.contentView.frame.width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5.0, left: 0, bottom: 5.0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
}

extension GalleryViewController {
    
    @IBAction func photoClickAction(_ sender: UIButton) {
        
            if #available(iOS 14.0, *) {
                
                let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
                let cameraAction = UIAlertAction(title: "Camera", style: .default){
                    UIAlertAction in
                    
                    if Constant.checkCameraAccess(){
                        ImagePickerManager().pickImagefromCamera(self) {data, type, result in
                            if result {
                                DispatchQueue.main.async {
                                    
                                    if let image = UIImage(data: data) {
                                        self.insertPhoto(image: image)
                                    }
                                    self.reloadPhotoSection()
                                }
                                
                            }
                            else {}
                        }
                    }
                }
                let galleryAction = UIAlertAction(title: "Gallery", style: .default){
                    
                    UIAlertAction in
                    if Constant.checkforLibraryAccess(){
                        
                        DispatchQueue.main.async {
                            var config = PHPickerConfiguration()
                            config.selectionLimit = 10
                            config.filter = PHPickerFilter.images
                            let pickerController = PHPickerViewController(configuration: config)
                            pickerController.delegate = self
                            self.present(pickerController, animated: true)
                        }
                    }
                    else{
                        
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                    UIAlertAction in
                }
                alert.addAction(cameraAction)
                alert.addAction(galleryAction)
                alert.addAction(cancelAction)
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
            else {
                if Constant.checkCameraAccess() {
                    
                    ImagePickerManager().pickImageAlone(self) {data, type, result in
                        if result {
                            DispatchQueue.main.async {
                                
                                if let image = UIImage(data: data) {
                                    self.insertPhoto(image: image)
                                }
                                //self.imagePickArray.insert(returnImage(path: "", image: image!), at: 0)
                                self.reloadPhotoSection()
                            }
                        }
                        else {}
                    }
                }
            }
        }
        
       
    }
    
extension GalleryViewController : PHPickerViewControllerDelegate {
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        let imageItems = results .map { $0.itemProvider } .filter { $0.canLoadObject(ofClass: UIImage.self) }
        let dispatchGroup = DispatchGroup()
        for imageItem in imageItems {
                dispatchGroup.enter() // signal IN
                imageItem.loadObject(ofClass: UIImage.self) { image, error in
                    debugPrint("Error : \(error.debugDescription)")
                    if let image = image as? UIImage {
                        self.insertPhoto(image: image)
                    }
                    dispatchGroup.leave() // signal OUT
                    //self.insertPhoto()
                }
            
            
        }
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.reloadPhotoSection()
            }
        }
    }
    
    
    @available(iOS 14, *)
    func pickerController(_ controller: PHPickerViewController, didSelect images: [UIImage]?) {
        
        controller.dismiss(animated: true, completion: nil)
        if(images!.count > 0) {
            for img in images!{
                //self.imagePickArray.insert(returnImage(path: "", image: img), at: 0)
            }
        }
        self.reloadPhotoSection()
    }
}
    
extension GalleryViewController {
    
    
    func insertPhoto(image : UIImage) {
        
        let path = Constant.saveImageToDocumentDirectory(image: image)
        let prefix = "\(path.split(separator: ".").first!)"
        ImagesViewModal.insertPhotoList(name: prefix, location: path)
    }
    
    
    @objc func deletePhoto(sender : UIButton ) {
        confirmedDeleteAfterAlert(atIndex: sender.tag)
    }
    
    func confirmedDeleteAfterAlert(atIndex : Int) {
        let img = self.imagesVM.imagesArray[atIndex]
        self.imagesVM.imagesArray.removeAll()
        self.photosCollectionV.reloadData()
        Constant.deleteImageIfExist(imageName: img.location ?? "")
        self.imagesVM.deleteImg(name: img.imgName ?? "")
        self.reloadPhotoSection()
    }
}
