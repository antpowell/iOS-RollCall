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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func signInUserWithEmailWasPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: userEmailAddressField.text!, password: userPasswordField.text!) { (user, error) in
            if error != nil{
                
            }
        }
    }
    
    @IBAction func createNewUserWasPressed(_ sender: Any) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterVC")
        present(registerVC!, animated: true, completion: nil)
    }
}
