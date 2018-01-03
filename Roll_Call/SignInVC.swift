//
//  SignInVC.swift
//  Roll_Call
//
//  Created by Anthony Powell on 11/27/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet var userEmailAddressField: InsetTextField!
    @IBOutlet var userPasswordField: InsetTextField!
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        
    }
    
    @IBAction func signInUserWithEmailWasPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        if userEmailAddressField.text != nil && userPasswordField.text != nil {
            AuthService.instance.loginUser(
                withEmail: userEmailAddressField.text!, andPassword: userPasswordField.text!, loginComplete: {
                    (success, user, loginError) in
                    if success {
                        DataService.instance.fetchUser(user: user!, completion: { (currentUser) in
                            if currentUser.wasUserCreated {
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                let courseSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "CourseSelectionVC")
                                self.present(courseSelectionVC!, animated: true, completion: nil)
                            }
                        })
                    }else if loginError?.localizedDescription != nil{
                        
                        switch loginError!.localizedDescription{
                        case "The email address is already in use by another account.":
                            print(loginError!.localizedDescription)
                            break
                        default:
                            print(loginError!.localizedDescription)
                            break
                            
                        }
                    }
            })
        }
    }
        
        @IBAction func createNewUserWasPressed(_ sender: Any) {
            let registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterVC")
            present(registerVC!, animated: true, completion: nil)
        }
}
