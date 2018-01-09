//
//  RegistrationVC.swift
//  Roll_Call
//
//  Created by Anthony Powell on 11/30/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var lNameReg: UITextField!
    @IBOutlet var tNumReg: UITextField!
    @IBOutlet var passwordReg: UITextField!
    @IBOutlet var eMailReg: UITextField!
    
    @IBOutlet var regBtn: UIButton!
    
    var lnChanged = false
    var tnChanged = false
    var userDataFound = false
    var userDataObject:[String:String] = [:]
    var loginSigninSuccess = false
    
    let userDefault = UserDefaults.standard
    
    @IBAction func registrationToCourseSegue(_ sender: Any) {
        registerUser()
        
        let encodedStudent = NSKeyedArchiver.archivedData(withRootObject: Users.public_instance.getUserAsUsers())
        
        userDefault.set(encodedStudent, forKey: "_student")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefault.set("Empty", forKey: "lNameKey")
        userDefault.set("Empty", forKey: "tNumKey")
        
        cancleReg()
        
        lNameReg.delegate = self
        tNumReg.delegate = self
 
    }
    
    func registerUser(){
        AuthService.instance.registerUser(withEmail: eMailReg.text!, andPassword: passwordReg.text!) { (success, user, err) in
            if success {
                Users.public_instance.setInitValues(name:self.lNameReg.text!, id:self.tNumReg.text!, email:self.eMailReg.text!, password: self.passwordReg.text!)
                DataService.instance.storeUserDataInDB(user: user!, userStored: { (success) in
                    if (success) {
                        print("Now we have a user from all callbacks.")
                        let courseSelectionView = self.storyboard?.instantiateViewController(withIdentifier: "CourseSelectionVC")
                        self.present(courseSelectionView!, animated: true, completion: nil)
                    }
                })
            }else if err != nil{
                switch err!.localizedDescription{
                case "The password must be 6 characters long or more.":
                    print("Password is not strong enough: \(err!.localizedDescription)")
                case "The email address is already in use by another account.":
                    print("User already exist, Sigining user in...")
                    // user already has an account with that email send them to sign in with that email.
                default:
                    print("ERROR: \(err!.localizedDescription)")
                }
            }
            
        }

    }

    
    
    // This is called to remove the first responder for the text field.
    func resign() {
        self.resignFirstResponder()
    }
    
    
    @objc func endEditingNow(){
        userDefault.set(lNameReg.text, forKey: "lNameKey")
        userDefault.set(tNumReg.text, forKey: "tNumKey")
        userDefault.set(eMailReg.text, forKey: "Email")
        userDefault.synchronize()
        
        let lnDefault: AnyObject! = userDefault.string(forKey: "lNameKey") as AnyObject!
        let tnDefualt : AnyObject! = userDefault.string(forKey: "tNumKey") as AnyObject!
        
        print("Checking Values... user defaults are \(lnDefault) T\(tnDefualt)")
        
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditingNow()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField{
        case lNameReg:
            self.lNameReg.resignFirstResponder()
            self.tNumReg.becomeFirstResponder()
            break
        case tNumReg:
            self.tNumReg.resignFirstResponder()
            self.eMailReg.becomeFirstResponder()
            break
        case eMailReg:
            self.eMailReg.resignFirstResponder()
            self.passwordReg.becomeFirstResponder()
            break
        case passwordReg:
            passwordReg.resignFirstResponder()
            registrationToCourseSegue(self)
            break
        default:
            resign()
        }
        
        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range , with: string)
        
        if Int(text) != nil{
            //enable button here
            if (text.count == 8){
                textField.textColor = UIColor.black
                enableReg()
            }else{
                cancleReg()
            }
        }else{
            //disable button here
            if textField == tNumReg{
                textField.textColor = UIColor.red
                cancleReg()
            }
            
        }
        return true
    }
    
    // When clicking on the field, use this method.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Create a button bar for the number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.endEditingNow) )
        let toolbarButtons = [item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }
    
    // What to do when a user finishes editting
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //nothing fancy here, just trigger the resign() method to close the keyboard.
        resign()
    }
    
    
    func cancleReg(){
        regBtn.isEnabled = false
    }
    
    
    func enableReg(){
        if !lNameReg.text!.isEmpty && !tNumReg.text!.isEmpty{
            if isValidEmailAddress(emailAddressString: eMailReg.text!){
                regBtn.isEnabled = true
            }
            regBtn.isEnabled = true
        }
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
