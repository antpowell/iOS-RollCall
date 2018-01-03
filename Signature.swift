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
    var _date: String!
    var _time: String!
    var _pass: String!
    var userSig: [String: Any]!
    
    init(course: String, password: String){
        _course = course
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
        userSig = Users.public_instance.getUser()
        userSig["POD"] = _pass
        userSig["Time"] = _time
        let signature = [_course:[_date:[userSig["_tNum"] as! String:userSig!]]]
        return signature
    }
}
