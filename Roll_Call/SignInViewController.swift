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
import SCLAlertView

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    let drNum1 = "8327418926"
    let drNum = "7138998111"
    let userDefault = UserDefaults.standard
    let messageComposer = MessageComposer()
    let rootRef = Database.database().reference()
    let userData = [String: Any]()
    
    var attendanceRef, userRef: DatabaseReference!
    var firebaseLoginObject: [String:String]! = [:]

    @IBOutlet var courseTitle: UILabel!
    @IBOutlet var enteredPass: UITextField!
    @IBOutlet var backBtn: UIButton!
    
//    var labelData: String! {
//        didSet{
//            print("\(labelData)... Recieved")
//        }
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = userDefault.string(forKey: "courseKey")
        print("courseTitle.text = \(data!)")
        courseTitle.text = data
//
//        print("User:--------\(userDefault.object(forKey: "_student") ?? "--->No User Found!")")
//
//        print("Recieved regDoc info: \(Users.public_instance.getUser())")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserData(completion: @escaping () ->())/* -> String */{
        DataService.instance.fetchUser { _  in
            OneTimeSignature.instance.initSignature(course: self.userDefault.string(forKey: "courseKey")!, password_of_the_day: self.enteredPass.text!)
            print("One time sig:\n\(OneTimeSignature.instance.formateSignature().description)")
            completion()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signRollNotification(_ sender: AnyObject) {
        if (enteredPass.text?.isEmpty)!{
            let alert = SCLAlertView()
            alert.showError("WHOA", subTitle: "Must enter Password of The Day")
        }else{
            getUserData(completion: {
                let SCLAlert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                SCLAlert.addButton("Use this signature") {
                    self.sendRollWithSMS()
                    self.sendRollToDB()
                }
                SCLAlert.addButton("Cancel") {
                    SCLAlertView().showWarning("Canceling...", subTitle: "Your signature was not applied to the roll.")
                }
                let alertResponder:SCLAlertViewResponder = SCLAlert.showNotice("Verify Your Signature", subTitle: "\(OneTimeSignature.instance.printSignature())")
            })
        }
    }

    func sendRollWithSMS(){
        print("Text message prepared.")
        if(self.messageComposer.canSendText()){
            let messageComposeVC = self.messageComposer.configureMessageComposeViewController(self.drNum, messageBody: OneTimeSignature.instance.smsSignature() as String)
            self.present(messageComposeVC, animated: true, completion: nil)
        }else{
            let errorAlert = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            print("This device can not send text.")
        }
        
    }
    
    func sendRollToDB(){
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
