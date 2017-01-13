//
//  ViewController.swift
//  Roll_Call
//
//  Created by Anthony Powell on 8/22/15.
//  Copyright (c) 2015 Anthony Powell. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIApplicationDelegate {
    
    @IBOutlet var lNameReg: UITextField!
    @IBOutlet var tNumReg: UITextField!
    @IBOutlet var regBtn: UIBarButtonItem!
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tNumberSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var lnChanged = false
    var tnChanged = false
    var userDataFound = false
    
    let userDefault = UserDefaults.standard
    
    @IBOutlet var registrationInputContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userDefault.set("Empty", forKey: "lNameKey")
        userDefault.set("Empty", forKey: "tNumKey")
        
        
        cancleReg()
        
        //lNameReg.delegate = self
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
    
    
    func endEditingNow(){
        userDefault.set(lNameReg.text, forKey: "lNameKey")
        userDefault.set(tNumReg.text, forKey: "tNumKey")
        
        let lnDefault: AnyObject! = userDefault.string(forKey: "lNameKey") as AnyObject!
        let tnDefualt : AnyObject! = userDefault.string(forKey: "tNumKey") as AnyObject!
        
        print("Checking Values... user defaults are \(lnDefault) T\(tnDefualt)")
        
        self.view.endEditing(true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditingNow()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == lNameReg{
            self.tNumReg.becomeFirstResponder()
        }else{
            resign()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range , with: string)
        
        if Int(text) != nil{
            //enable button here
            if (text.characters.count==8){
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
            regBtn.isEnabled = true
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        userDefault.set(lNameReg.text, forKey: "lNameKey")
        userDefault.set(tNumReg.text, forKey: "tNumKey")
        
        
    }


}

