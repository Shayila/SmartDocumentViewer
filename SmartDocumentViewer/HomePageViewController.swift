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

    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var welcomeLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signOutBtn.setTitle("Sign Out", for: .normal)
        welcomeLbl.text = Constant.profile?.profile?.name ?? ""
    }
    

    @IBAction func openPDFFile(_ sender: Any) {
        
        Constant.openFileViewerVC()
        
    }
    @IBAction func signOutAction(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        
        Constant.callLoginPageVC()
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
