//
//  Signature.swift
//  Roll_Call
//
//  Created by Anthony Powell on 11/5/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import Foundation

class Signature: NSObject{
    var _course: String!
    var _user: Users!
    var _date: String!
    var _time: String!
    var _pass: String!
    var userSig: [String: Any]!
    
    init(course: String, user: Users, password: String){
        _course = course
        _user = user
        _pass = password
    }
    
    func setDateTime(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "E, MMM d, yyyy"
        let timeFormatter  = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .medium
        timeFormatter.dateFormat = "HH:mm"
        _date = dateFormatter.string(from: Date())
        _time = timeFormatter.string(from: Date())
    }
    
    func getFormattedSignature() -> Dictionary<String, Any>{
        setDateTime()
        userSig = _user.getUser()[_user._tNum]! as! [String : Any]
        userSig["POD"] = _pass
        userSig["Time"] = _time
        let signature = [_course:[_date:[_user._tNum:userSig]]]
//        signature["_course"]=_course
        return signature
    }
}
