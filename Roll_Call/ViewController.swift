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
    
    var lnChanged = false
    var tnChanged = false
    var userDataFound = false
    
    let userDefault = NSUserDefaults.standardUserDefaults()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userDefault.setObject("Empty", forKey: "lNameKey")
        userDefault.setObject("Empty", forKey: "tNumKey")
        
        cancleReg()
        
        //lNameReg.delegate = self
        tNumReg.delegate = self
        
        if getUserData() == true{
            
//            performSegueWithIdentifier("CourseSelection", sender: self)
            
            let nextView : AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("CourseSelection")
            self.showViewController(nextView as! UIViewController, sender: nextView)
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    func getUserData() -> Bool {
        if ((userDefault.stringForKey("lNameKey")) != "Empty") {
            let user : AnyObject! = userDefault.stringForKey("lNameKey")
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
        userDefault.setObject(lNameReg.text, forKey: "lNameKey")
        userDefault.setObject(tNumReg.text, forKey: "tNumKey")
        
        let lnDefault: AnyObject! = userDefault.stringForKey("lNameKey")
        let tnDefualt : AnyObject! = userDefault.stringForKey("tNumKey")
        
        print("Checking Values... user defaults are \(lnDefault) T\(tnDefualt)")
        
        self.view.endEditing(true)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        endEditingNow()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == lNameReg{
            self.tNumReg.becomeFirstResponder()
        }else{
            resign()
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range , withString: string)
        
        if let intVal = Int(text){
            //enable button here
            if (text.characters.count==8){
                textField.textColor = UIColor.blackColor()
                enableReg()
                }else{
                cancleReg()
            }
        }else{
            //disable button here
            if textField == tNumReg{
                textField.textColor = UIColor.redColor()
                cancleReg()
            }
            
        }
        return true
    }
    
    // When clicking on the field, use this method.
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Create a button bar for the number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let item = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("endEditingNow") )
        let toolbarButtons = [item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }
    
    // What to do when a user finishes editting
    func textFieldDidEndEditing(textField: UITextField) {
        
        //nothing fancy here, just trigger the resign() method to close the keyboard.
        resign()
    }
    
    
    func cancleReg(){
        regBtn.enabled = false
    }
    
    
    func enableReg(){
        if !lNameReg.text!.isEmpty && !tNumReg.text!.isEmpty{
            regBtn.enabled = true
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        userDefault.setObject(lNameReg.text, forKey: "lNameKey")
        userDefault.setObject(tNumReg.text, forKey: "tNumKey")
        
        
    }


}

