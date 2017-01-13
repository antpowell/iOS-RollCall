//
//  LoginRegistrationViewController.swift
//  Roll_Call
//
//  Created by Anthony Powell on 8/6/16.
//  Copyright © 2016 Anthony Powell. All rights reserved.
//

import UIKit
import Firebase
//import GoogleSignIn

class LoginRegistrationViewController: UIViewController {
    let imgView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var inputContainerHeightConstraints: NSLayoutConstraint?
    var nameTextFieldHeightConstraint: NSLayoutConstraint?
    var tNumberTextFieldHeightConstraint: NSLayoutConstraint?
    var emailTextFieldHeightConstraint: NSLayoutConstraint?
    var passwordTextFieldHeightConstraint: NSLayoutConstraint?
    
    lazy var loginSegmentedController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(segmentControlerHandler), for: .valueChanged)
        return sc
    }()
    
    let inputsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var registrationButton :UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.setTitle("Register", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleLoginRegister),for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let txtFld = UITextField()
        txtFld.placeholder = "Last Name"
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        
        return txtFld
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let txtFld = UITextField()
        txtFld.placeholder = "E-Mail"
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        
        return txtFld
    }()
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let passwordTextField: UITextField = {
        let txtFld = UITextField()
        txtFld.placeholder = "Password"
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        txtFld.isSecureTextEntry = true
        return txtFld
    }()
    let tNumberTextField: UITextField = {
        let txtFld = UITextField()
        txtFld.placeholder = "8-digit TNumber(numbers only)"
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        txtFld.keyboardType = UIKeyboardType.numberPad
        return txtFld
    }()
    let tNumberSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        
        view.addSubview(loginSegmentedController)
        view.addSubview(inputsContainerView)
        view.addSubview(registrationButton)
        
        loginSegmentedControllerConstraints()
        inputContainerConstraints()
        registerButtonConstraints()
        tNumberTFConstraints()
        emailTFConstraints()
        passwordTFConstraints()
        
    }
    
    func loginSegmentedControllerConstraints(){
        //x, y, weigth, height constrants
        loginSegmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginSegmentedController.bottomAnchor.constraint(lessThanOrEqualTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginSegmentedController.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginSegmentedController.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func inputContainerConstraints(){
        //constraints x, y, height, width
        inputContainerHeightConstraints = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerHeightConstraints?.isActive = true
        //Adding TextField Views to inputs Container
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(tNumberTextField)
        inputsContainerView.addSubview(tNumberSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        //Give TextField Views Constraints
        nameTFConstraints()
    }
    func registerButtonConstraints(){
        //constraints x, y, height, width
        registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registrationButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        registrationButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        registrationButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    
    func nameTFConstraints(){
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightConstraint?.isActive = true
        //Separator View
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.bottomAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    func tNumberTFConstraints(){
        tNumberTextFieldHeightConstraint = tNumberTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        tNumberTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        tNumberTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 12).isActive = true
        tNumberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        tNumberTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        tNumberTextFieldHeightConstraint?.isActive = true
        //Separator View
        tNumberSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        tNumberSeparatorView.bottomAnchor.constraint(equalTo: tNumberTextField.bottomAnchor).isActive = true
        tNumberSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        tNumberSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    func emailTFConstraints(){
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: tNumberTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightConstraint?.isActive = true
        //Name Separator View
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.bottomAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    func passwordTFConstraints(){
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightConstraint?.isActive = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    func segmentControlerHandler(){
        let title =  loginSegmentedController.titleForSegment(at: loginSegmentedController.selectedSegmentIndex)
        registrationButton.setTitle(title, for: UIControlState())
        inputContainerHeightConstraints?.constant = loginSegmentedController.selectedSegmentIndex == 0 ? 100 : 150
        inputContainerHeightConstraints?.isActive = true
        //Name Field Height
        nameTextFieldHeightConstraint?.isActive = false
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginSegmentedController.selectedSegmentIndex == 0 ? 0 : 1/4)
        nameTextFieldHeightConstraint?.isActive = true
        //T Number Field Height
        tNumberTextFieldHeightConstraint?.isActive = false
        tNumberTextFieldHeightConstraint = tNumberTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginSegmentedController.selectedSegmentIndex == 0 ? 0 : 1/4)
        tNumberTextFieldHeightConstraint?.isActive = true
        //Email Field Height
        emailTextFieldHeightConstraint?.isActive = false
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        emailTextFieldHeightConstraint?.isActive = true
        //Password Field Height
        passwordTextFieldHeightConstraint?.isActive = false
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        passwordTextFieldHeightConstraint?.isActive = true
        return
    }
    
    
    func handleLoginRegister(){
        if loginSegmentedController.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
            handleReg()
        }
    }
    func handleLogin(){
        guard let email = emailTextField.text , let password = passwordTextField.text
            else{
                print("Login Form Not Valid")
                return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil{
                print(error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    
    func handleReg(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, let tNumber = tNumberTextField.text, tNumberTextField.text?.characters.count == 8
            else{
                inputsContainerView.layer.borderWidth = 3
                inputsContainerView.layer.borderColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
                inputsContainerView.layer.masksToBounds = true
                print("Form not valid")
                return
        }
        print("Register was pressed.")
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil{
                print(error)
                return
            }
            guard let uid = user?.uid else{
                return
            }
            let ref = FIRDatabase.database().reference(fromURL: "https://roll-call-2.firebaseio.com/")
            let tNum = "T"+tNumber
            let testref = ref.child("FBTester")
            let IDRef = testref.child("IDs").child(uid)
            let userRef = ref.child("FBTester").child("Users")
            
            let UIDScheme = ["T Number" : tNum]
            let values = ["Email" : email, "Name" : name, "T Number" : tNum]
            
            IDRef.updateChildValues(UIDScheme, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err)
                    return
                }
                print("Saved ID without error")
            })
            userRef.child(tNum).updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err)
                    return
                }
                print("Saved user without error")
            })
            print("Registratin Complete without error")
            //successfully authenticated user
            self.dismiss(animated: true, completion: nil)
        })
        
    }
}
