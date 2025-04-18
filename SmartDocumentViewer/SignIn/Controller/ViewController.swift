//
//  ViewController.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 11/04/25.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var welcomeLbl: UILabel!
    
    
    var viewModal : SignInViewModal {
        let modal = SignInViewModal()
        return modal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        
        restoreSignInAction()
        
    }

    
    func userProfileAfterSuccess(user : GIDGoogleUser){
        
            print("\(user.profile?.name ?? "")")

            self.welcomeLbl.isHidden = false
            self.welcomeLbl.text = "Welcome '\(user.profile?.name ?? "")' "
            self.googleBtn.isHidden = true
            
            viewModal.saveUserDetail(name: user.profile?.name ?? "", email: user.profile?.email ?? "", imgUrl: user.profile?.imageURL(withDimension: 200)?.path ?? "")
            
            UserDefaults.standard.set(user.profile?.email ?? "", forKey: "email")
            Constant.callHomePageVC()
        
    }
    
    
    
    
    func restoreSignInAction(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
                DispatchQueue.main.async {
                    self.viewModal.deleteEntireEntities()
                }
            } else {
              // Show the app's signed-in state.
                DispatchQueue.main.async {
                    
                    if let user = user {                        
                        self.userProfileAfterSuccess(user: user)
                    }
                }
                
            }
          }
    }
    
    
    
    @IBAction func googleSignInAction(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            
            if error != nil || signInResult == nil{
                DispatchQueue.main.async {
                    self.viewModal.deleteEntireEntities()
                }
            }

           else if let signinResult = signInResult {
                // If sign in succeeded, display the app's main content View.
                
                DispatchQueue.main.async {
                    let listVM = ListpageViewModal()
                    listVM.fetchListFromAPI()
                    self.userProfileAfterSuccess(user: signinResult.user)
                }

                
            }
         }
        
    }
    
}

