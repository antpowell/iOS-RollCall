//
//  SignInVC.swift
//  Roll_Call
//
//  Created by Anthony Powell on 11/27/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class SignInVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet var userEmailAddressField: InsetTextField!
    @IBOutlet var userPasswordField: InsetTextField!
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEmailAddressField.delegate = self
        userPasswordField.delegate = self
        
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
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self.activityIndicator.stopAnimating()
                                let appearance = SCLAlertView.SCLAppearance(
                                    showCloseButton: false
                                )
                                let alert = SCLAlertView(appearance: appearance)
                                alert.addButton("OK", action: {
                                    let courseSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "CourseSelectionVC")
                                    self.present(courseSelectionVC!, animated: true, completion: nil)
                                })
                                alert.showSuccess("Congratulations", subTitle: "Log in successful")
                                
                            }
                        })
                    }else if loginError?.localizedDescription != nil{
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        switch loginError!.localizedDescription{
                        case "The email address is already in use by another account.":
                            SCLAlertView().showError("Login Error", subTitle: loginError!.localizedDescription)
                            break
                        default:
                            SCLAlertView().showError("Login Error", subTitle: loginError!.localizedDescription)
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

extension SignInVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userEmailAddressField:
            userEmailAddressField.resignFirstResponder()
            userPasswordField.becomeFirstResponder()
        case userPasswordField:
            signInUserWithEmailWasPressed(self)
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userEmailAddressField.resignFirstResponder()
        userPasswordField.resignFirstResponder()
    }
}
