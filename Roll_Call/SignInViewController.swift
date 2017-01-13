//
//  SignInViewController.swift
//  Roll_Call
//
//  Created by Anthony Powell on 8/22/15.
//  Copyright (c) 2015 Anthony Powell. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {

    
    let drNum1 = "8327418926"
    let drNum = "7138998111"
    let date = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
    let userDefault = UserDefaults.standard
    let messageComposer = MessageComposer()
    let rootRef = FIRDatabase.database().reference()

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
    
    override func viewDidAppear(_ animated: Bool) {
        let attendanceRef = rootRef.child("Attendance")
        attendanceRef.observe(.value){(snap: FIRDataSnapshot) in
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserData() -> NSString{
        if let primeU = userDefault.string(forKey: "lNameKey"){
            if let primeT = userDefault.string(forKey: "tNumKey"){
                if let primeC = userDefault.string(forKey: "courseKey"){
                    if let primePass = userDefault.string(forKey: "passKey"){
                        
                        
                        return "\(primeC),\(primeU),T\(primeT),\(date),\(primePass)" as NSString
                    }
                    
                }
            }
        }
        return "No Data Found"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signRollNotification(_ sender: AnyObject) {
        userDefault.set(enteredPass.text, forKey: "passKey")
        
        let alert = UIAlertController(title: "You are about to sign the roll.", message: "Your current data consist of: \(getUserData())", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            let innerAlert = UIAlertController(title: "Canceling", message: "You have decided to cancel signing the roll.", preferredStyle: .alert)
            let innerOKAction = UIAlertAction(title: "OK", style: .default){ action -> Void in
            }
            innerAlert.addAction(innerOKAction)
            self.present(innerAlert, animated: true, completion: nil)
            print("You have decided to cancel signing the roll.")
    }
        let okAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            self.sendRoll()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        print("Composing Message...")
        self.present(alert, animated: true, completion: nil )
        
        print(getUserData())
        
        
        
    }

    func sendRoll(){
        print("Text message prepared.")
        if(self.messageComposer.canSendText()){
            let messageComposeVC = self.messageComposer.configureMessageComposeViewController(self.drNum, messageBody: self.getUserData() as String)
            self.present(messageComposeVC, animated: true, completion: nil)
        }else{
            let errorAlert = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            print("This device can not send text.")
        }


    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    

}
