//
//  Users.swift
//  Roll_Call
//
//  Created by Anthony Powell on 1/24/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn

class Users: NSObject, NSCoding {
    var _lastName: String!
    var _tNum: String!
    var _email: String!
    var _password: String!
    var _pod: String!
    var wasUserCreated: Bool!
    let rootRef: DatabaseReference! = Database.database().reference();
    
    override init(){}
    
    required init(coder decoder:NSCoder){
        self._lastName = decoder.decodeObject(forKey:"_lastName") as? String
        self._tNum = decoder.decodeObject(forKey:"_tNum") as? String
        self._email = decoder.decodeObject(forKey:"_email") as? String
    }
    
    init(name:String, id:String, email:String, password:String){
        self._lastName = name;
        self._tNum = "T\(id)";
        self._email = email;
        self._password = password;
        
    }
    init(name:String, id:String, email:String) {
        self._lastName = name;
        self._tNum = "T\(id)";
        self._email = email;
    }
    
    
    func getUser() -> [String: Any]{
        let userObj = [_tNum:
            ["_email":_email,
             "_lastName": _lastName,
             "_tNum": _tNum]
        ]
        return userObj
    }
    
    /**
     * Input Example
     * TNumber
     *      _email
     *      _lastName
     *      _tNum
     */
    func storeUserInDB(){
        rootRef.child("Users")
            .child(_tNum)
            .setValue(["_email":_email!,
                       "_lastName": _lastName!,
                       "_tNum": _tNum!])
    }
    
    func CreateNewUserDB(user:Users) -> Bool{
        let signInHandler = SignInHandler(user:user, pw:_password)
        signInHandler.creatUserWithEmail()
        print(Auth.auth().currentUser! as Any)
        print(signInHandler.success)
        return signInHandler.success
    }
    
//    func CreateNewUser(user:Users) -> Promise<Bool>{
//        return Promise({fulfil, error in
//            DispatchQueue.global(qos: .background).async {
//                if let signInHanderler = SignInHandler(user:user, pw:_password){
//                    fulfil(true)
//                }else{
//                    reject(error)
//                }
//            }
//        })
//    }
    
    func CreateNewUserWithGoogle(user:Users){
        
    }
    
    func encode(with coder: NSCoder){
        coder.encode(_lastName, forKey: "_lastName")
        coder.encode(_tNum, forKey: "_tNum")
        coder.encode(_email, forKey: "_email")
    }
    
    

}
