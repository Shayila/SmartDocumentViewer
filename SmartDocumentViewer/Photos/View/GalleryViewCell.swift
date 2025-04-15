//
//  GalleryViewCell.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 15/04/25.
//

import UIKit

class GalleryViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoTypeNameLbl: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var photoTypeHeightCons: NSLayoutConstraint!
    static let reuseId = "GalleryViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var configPhoto : String? {
        didSet {
            if let model = configPhoto {
                if let image = Constant.getGalleryImage(path: model){
                    self.imageView.image = image
                }
                
                
            }
        }
    }
    
    
}
