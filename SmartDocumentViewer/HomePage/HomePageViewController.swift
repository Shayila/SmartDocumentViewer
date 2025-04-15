//
//  HomePageViewController.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 14/04/25.
//

import UIKit
import GoogleSignIn
import PDFKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var pdfFile: UIButton!
    
    
    var signInviewModal : SignInViewModal {
        let modal = SignInViewModal()
        modal.fetchUserDetails()
        return modal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home Page"
        // Do any additional setup after loading the view.
        profileImg.setImage( "https://lh3.googleusercontent.com\(signInviewModal.signInDetail.imageURL)", "BGImage")
        welcomeLbl.text = "Welcome \(signInviewModal.signInDetail.name)"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constant.checkCameraAccess()
        Constant.checkforLibraryAccess()
    }
    
    @IBAction func openPhotosVC(_ sender: UIButton) {
        Constant.openPhotosVC()
    }
    
    @IBAction func openPDFFile(_ sender: Any) {
        
        Constant.openFileViewerVC()
        
    }
    @IBAction func ListPageAction(_ sender: UIButton) {
        
        Constant.openListViewVC()
    }
    @IBAction func signOutAction(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        signInviewModal.deleteUserDetail()
        Constant.callLoginPageVC()
    }
    
    
    @IBAction func alertNotificationAction(_ sender: UIButton) {
        if let alert = UserDefaults.standard.value(forKey: "") as? Bool {
            var val = alert
            UserDefaults.standard.set(val.toggle(), forKey: "Alert_Enabled")
        }
        else {
            UserDefaults.standard.set(false, forKey: "Alert_Enabled")
        }
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
