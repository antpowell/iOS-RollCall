//
//  AuthService.swift
//  Roll_Call
//
//  Created by Anthony Powell on 11/20/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import Foundation
import Firebase

class AuthService{
    static let instance = AuthService()
    
    func registerUser(withEmail email:String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool,_ user: User?, _ error: Error?) -> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                //error creating user
                userCreationComplete(false, nil, error)
            }else{
                    userCreationComplete(true, user, error)
            }
        }
    }
    
    
    func loginUser(withEmail email:String, andPassword  password: String, loginComplete: @escaping (_ status: Bool, _ user: User?, _ error: Error?) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                loginComplete(false, nil, error)
                return
            }
            loginComplete(true, user!, nil)
        }
    }
}
