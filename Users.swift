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
    var wasUserCreated: Bool! = false
    let rootRef: DatabaseReference! = Database.database().reference();
    
    static let public_instance = Users()
    
    override init(){}
    
    required init(coder decoder:NSCoder){
        self._lastName = decoder.decodeObject(forKey:"_lastName") as? String
        self._tNum = decoder.decodeObject(forKey:"_tNum") as? String
        self._email = decoder.decodeObject(forKey:"_email") as? String
        self.wasUserCreated = true
    }
    
    init(name:String, id:String, email:String, password:String){
        self._lastName = name;
        self._tNum = "T\(id)";
        self._email = email;
        self._password = password;
        self.wasUserCreated = true
    }
    
    init(name:String, id:String, email:String) {
        self._lastName = name;
        self._tNum = "T\(id)";
        self._email = email;
        self.wasUserCreated = true
    }
    
    func setInitValues(name:String, id:String, email:String) {
        self._lastName = name;
        self._tNum = "T\(id)";
        self._email = email;
        self.wasUserCreated = true
    }
    
    func setInitValues(name:String, id:String, email:String, password:String) {
        self._lastName = name;
        self._tNum = "T\(id)";
        self._email = email;
        self._password = password;
        self.wasUserCreated = true
    }
    
    func getUser() -> [String: Any]{
        DataService.instance.fetchUser { (user) in
    
        }
        return ["_email":self._email,
                "_lastName": self._lastName,
                "_tNum": self._tNum]
    }
    
    func getEmail() -> String{
        return _email
    }
    
    func getLastName() -> String{
        return _lastName
    }
    
    func getTNum() -> String{
        return _tNum
    }
    
    func getUserAsUsers() -> Users{
        return self
    }
    
    func printUser() -> String{
        return "Last Name: \(_lastName)\nTNumber: \(_tNum)\nEmail: \(_email)\n"
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
            .setValue(["_email": _email!,
                       "_lastName": _lastName!,
                       "_tNum": _tNum!])
    }
    
    func createUserWEmail(user:Users, completion: @escaping (Bool) -> ()){
        let signInHandler = SignInHandler(user:user, pw:_password)
        signInHandler.creatUserWithEmail { _ in
            print("Our completion says: \(signInHandler.success)")
            completion(signInHandler.success)
        }
    }
    
    func createUserWGoogle(user:Users){
        
    }
    
    func createUserWFb(user:Users){
        
    }
    
    func encode(with coder: NSCoder){
        coder.encode(_lastName, forKey: "_lastName")
        coder.encode(_tNum, forKey: "_tNum")
        coder.encode(_email, forKey: "_email")
    }
    
    func formateUser(userSnapshot: [String: Any], completion: @escaping (Users) -> ()){
        print(userSnapshot.description)
        self._tNum = userSnapshot["_tNum"] as! String
        self._email = userSnapshot["_email"] as! String
        self._lastName = userSnapshot["_lastName"] as! String
        self.wasUserCreated = true
        completion(self)
    }
    
    func createUserRecord(_ user: User, recordWasCreated: @escaping (Bool) -> ()){
        DataService.instance.storeUserDataInDB(user: user) { (wasUserDataStored) in
            recordWasCreated(wasUserDataStored)
        }
    }
    

}
