//
//  SignInViewController.swift
//  Roll_Call
//
//  Created by Anthony Powell on 8/22/15.
//  Copyright (c) 2015 Anthony Powell. All rights reserved.
//

import UIKit
import MessageUI

class SignInViewController: UIViewController, UITextFieldDelegate {

    
    let drNum1 = "8327418926"
    let drNum = "7138998111"
    let date = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    let userDefault = NSUserDefaults.standardUserDefaults()
    let messageComposer = MessageComposer()

    @IBOutlet var courseTitle: UILabel!
    @IBOutlet var enteredPass: UITextField!
    
    var labelData: String! {
        didSet{
            print("\(labelData)... Recieved")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let data = labelData
        courseTitle.text = data
        
        print("Recieved regDoc info: \(getUserData())")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserData() -> NSString{
        if let primeU = userDefault.stringForKey("lNameKey"){
            if let primeT = userDefault.stringForKey("tNumKey"){
                if let primeC = userDefault.stringForKey("courseKey"){
                    if let primePass = userDefault.stringForKey("passKey"){
                        
                        
                        return "\(primeC),\(primeU),T\(primeT),\(date),\(primePass)"
                    }
                    
                }
            }
        }
        return "No Data Found"
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signRollNotification(sender: AnyObject) {
        userDefault.setObject(enteredPass.text, forKey: "passKey")
        
        let alert = UIAlertController(title: "You are about to sign the roll.", message: "Your current data consist of: \(getUserData())", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            let innerAlert = UIAlertController(title: "Canceling", message: "You have decided to cancel signing the roll.", preferredStyle: .Alert)
            let innerOKAction = UIAlertAction(title: "OK", style: .Default){ action -> Void in
            }
            innerAlert.addAction(innerOKAction)
            self.presentViewController(innerAlert, animated: true, completion: nil)
            print("You have decided to cancel signing the roll.")
    }
        let okAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
            self.sendRoll()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        print("Composing Message...")
        self.presentViewController(alert, animated: true, completion: nil )
        
        print(getUserData())
        
        
        
    }

    func sendRoll(){
        print("Text message prepared.")
        if(self.messageComposer.canSendText()){
            let messageComposeVC = self.messageComposer.configureMessageComposeViewController(self.drNum, messageBody: self.getUserData() as String)
            self.presentViewController(messageComposeVC, animated: true, completion: nil)
        }else{
            let errorAlert = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", preferredStyle: UIAlertControllerStyle.Alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            print("This device can not send text.")
        }

    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    

}
