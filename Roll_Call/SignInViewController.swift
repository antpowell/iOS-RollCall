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
    let rootRef = Database.database().reference()
    
    var attendanceRef, userRef: DatabaseReference!
    var firebaseLoginObject: [String:String]! = [:]

    @IBOutlet var courseTitle: UILabel!
    @IBOutlet var enteredPass: UITextField!
    @IBOutlet var backBtn: UIButton!
    
    var labelData: String! {
        didSet{
            print("\(labelData)... Recieved")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = userDefault.string(forKey: "courseKey")
        print("courseTitle.text = \(data!)")
        courseTitle.text = data
        
        print("User:--------\(userDefault.object(forKey: "_student") ?? "--->No User Found!")")
        
        print("Recieved regDoc info: \(getUserData())")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let attendanceRef = rootRef.child("Attendance")
        attendanceRef.observe(.value){(snap: DataSnapshot) in
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserData() -> String{
        OneTimeSignature.instance.initSignature(course: userDefault.string(forKey: "courseKey")!, password_of_the_day: userDefault.string(forKey: "passKey")!)
//        let signature = OneTimeSignature(course: userDefault.string(forKey: "courseKey")!, password_of_the_day: userDefault.string(forKey: "passKey")!)
        print(OneTimeSignature.instance.formateSignature().description)
        return OneTimeSignature.instance.formateSignature().description
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
            self.sendRollWithSMS()
            self.sendRollToDB()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        print("Composing Message...")
        self.present(alert, animated: true, completion: nil )
        
        print(getUserData())
    }

    func sendRollWithSMS(){
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
    
    func sendRollToDB(){
        let encodedStudent = userDefault.data(forKey: "_student")
        let unarchivedStudent = NSKeyedUnarchiver.unarchiveObject(with: encodedStudent!) as? Users
        OneTimeSignature.instance.signIn()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
