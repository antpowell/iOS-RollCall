//
//  ViewController.swift
//  Roll_Call
//
//  Created by Anthony Powell on 8/22/15.
//  Copyright (c) 2015 Anthony Powell. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate, UIApplicationDelegate {

    @IBOutlet var lNameReg: UITextField!
    @IBOutlet var tNumReg: UITextField!
    @IBOutlet var passwordReg: UITextField!
    @IBOutlet var eMailReg: UITextField!
    
    @IBOutlet var regBtn: UIBarButtonItem!
    
    
    let rootRef: DatabaseReference! = Database.database().reference();
    var userRef: DatabaseReference!
    var lnChanged = false
    var tnChanged = false
    var userDataFound = false
    var userDataObject:[String:String] = [:]
    var loginSigninSuccess = false
    
    let userDefault = UserDefaults.standard
    
    @IBOutlet var registrationInputContainerView: UIView!
    @IBAction func registrationToCourseSegue(_ sender: Any) {
        let student = Users(name:lNameReg.text!, id:tNumReg.text!, email:eMailReg.text!, password: passwordReg.text!)
        let encodedStudent = NSKeyedArchiver.archivedData(withRootObject: student)
        
        userDefault.set(encodedStudent, forKey: "_student")
        userDefault.set(lNameReg.text, forKey: "lNameKey")
        userDefault.set(tNumReg.text, forKey: "tNumKey")
        userDefault.set(userDataObject, forKey: "userObject")
        
        userDataObject["TNum"] = tNumReg.text
        userDataObject["Last Name"] = lNameReg.text
        userDataObject["Email"] = eMailReg.text
        userDataObject["Password"] = passwordReg.text
        
        //        userRef
        //            .child("T\(userDataObject["TNum"]!)")
        //            .setValue(userDataObject)
        
        //
//        student.storeUserInDB()
//        loginSigninSuccess = student.CreateNewUserDB(user: student)
//        print(student.CreateNewUserDB(user: student))
//        if(student.CreateNewUserDB(user: student)){
//            self.performSegue(withIdentifier: "RegisterToCourses", sender: self)
//        }else{
//            // show message to use about there error
//            print("Could not create new user.")
//        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userDefault.set("Empty", forKey: "lNameKey")
        userDefault.set("Empty", forKey: "tNumKey")
        
//        userRef = rootRef.child("FBTester").child("Users")
        userRef = rootRef.child("Users")

        cancleReg()
        
        lNameReg.delegate = self
        tNumReg.delegate = self

        
        if getUserData() == true{
            
//            performSegueWithIdentifier("CourseSelection", sender: self)
            
            let nextView : AnyObject! = self.storyboard?.instantiateViewController(withIdentifier: "CourseSelection")
            self.show(nextView as! UIViewController, sender: nextView)
            
        }
    }
    
    
    func getUserData() -> Bool {
        if ((userDefault.string(forKey: "lNameKey")) != "Empty") {
            let user : AnyObject! = userDefault.string(forKey: "lNameKey") as AnyObject!
            print("Data is \(user)")
         return true
        }else{
            print("false")
            return false
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
            self.tNumReg.becomeFirstResponder()
            break
        case tNumReg:
            self.eMailReg.becomeFirstResponder()
            break
        case eMailReg:
            self.passwordReg.becomeFirstResponder()
            break
        case passwordReg:
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
//        Debug
//        regBtn.isEnabled = true
    }
    
    
    func enableReg(){
        if !lNameReg.text!.isEmpty && !tNumReg.text!.isEmpty{
            if isValidEmailAddress(emailAddressString: eMailReg.text!){
                regBtn.isEnabled = true
            }
            regBtn.isEnabled = true
        }
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let student = Users(name:lNameReg.text!, id:tNumReg.text!, email:eMailReg.text!, password: passwordReg.text!)
//        let encodedStudent = NSKeyedArchiver.archivedData(withRootObject: student)
//
//        userDefault.set(encodedStudent, forKey: "_student")
//        userDefault.set(lNameReg.text, forKey: "lNameKey")
//        userDefault.set(tNumReg.text, forKey: "tNumKey")
//        userDefault.set(userDataObject, forKey: "userObject")
//
//        userDataObject["TNum"] = tNumReg.text
//        userDataObject["Last Name"] = lNameReg.text
//        userDataObject["Email"] = eMailReg.text
//
//
////        userRef
////            .child("T\(userDataObject["TNum"]!)")
////            .setValue(userDataObject)
//
////
//        student.storeUserInDB()
//        loginSigninSuccess = student.CreateNewUserDB(user: student)
//
//    }
    

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

}

