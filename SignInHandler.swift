//
//  SignInHandler.swift
//  Roll_Call
//
//  Created by Anthony Powell on 11/13/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import Foundation
import Firebase

class SignInHandler{
    
    var eMail: String
    var password: String
    var success: Bool = false
    
//    override init(){}
    
    init(user: Users, pw: String){
        eMail = user._email
        if user._password != nil{
            password = user._password
        }else{
            password = pw
        }
    }
    
    func creatUserWithEmail(completion: @escaping (Bool) -> ()){
        Auth.auth().createUser(withEmail: eMail, password: password, completion: { (user, error) in
            if error != nil{
                switch error!.localizedDescription{
                case "The password must be 6 characters long or more.":
                    print("Password is not strong enough: \(error!.localizedDescription)")
                case "The email address is already in use by another account.":
                    print("User already exist, Sigining user in...")
                    self.signInWithEmail(completion: {(success) in
                        self.success = success
                        completion(success)
                    })
                default:
                    print("ERROR: \(error!.localizedDescription)")
                }
                //user account alread exist
                

            }else{
                //User was created inform them of that
                print("User was created successfully, now logging in")
                self.success = true
                completion(self.success)
            }
        })
        
    }
    
    func signInWithEmail(completion: @escaping (Bool) -> ()){
        Auth.auth().signIn(withEmail: eMail, password: password, completion: { (user, error) in
            if error != nil{
                //username or password is incorrect
                self.success = false
                print("Username and password not found")
                
            }else{
                //User successfully logged in, infrom them of that
                DataService.instance.REF_USERS.child((user?.uid)!).observeSingleEvent(of: .value, with: { (s) in
                    Users.public_instance.formateUser(userSnapshot: s.value(forKey: user!.uid) as! [String : Any], completion: { (currentUser) in
                        self.success = true
                        completion(self.success)
                        print((user?.email!)! + " has signed in.")
                    })
                })
            }
        })
        
    }
    
    func signOut(){
        try? Auth.auth().signOut()
    }
    
}


