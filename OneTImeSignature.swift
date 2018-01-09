//
//  OneTImeSignature.swift
//  Roll_Call
//
//  Created by Anthony Powell on 12/26/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import Foundation

class OneTimeSignature{
    private var _UID: String!
    private var _course: String!
    private var _user_lname: String!
    private var _password_of_the_day:String!
    private var _date:String?
    private var _time:String?
    private var _user:Users?
    private var user_data: [String: Any]?
    
    static let instance = OneTimeSignature()
    
    required init(course: String, password_of_the_day: String){
        self._course = course
        self._password_of_the_day = password_of_the_day
        self._UID = Users.public_instance._tNum
        self._user_lname = Users.public_instance._lastName
    }
    
    init(){}
    
    func initSignature(course: String, password_of_the_day: String){
        self._course = course
        self._password_of_the_day = password_of_the_day
        self._UID = Users.public_instance._tNum
        self._user_lname = Users.public_instance._lastName
    }
    
    func dateTimeSnapshot(){
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
    
    func formateSignature() -> [String: Any]{
        dateTimeSnapshot()
        
        user_data = (Users.public_instance.getUser())
        user_data!["POD"] = _password_of_the_day
        user_data!["Time"] = _time
        //        let signature = [_course!:[_date!:[_UID!:user_data!]]]
        let signature = user_data as! [String: Any]
        return signature
    }
    
    func printSignature() -> String {
        formateSignature()
//        return "Last Name: \(user_data!["_lastName"]!)\nTNumber: \(user_data!["_tNum"]!)\nEmail: \(user_data!["_email"]!)\nPassword of the day: \(user_data!["POD"]!)\nTime: \(user_data!["Time"]!)"
        return "nil"
    }
    
    func signIn(){
        DataService.instance.REF_ATTENDANCE.child(_course).child(_date!).child(_UID).setValue(user_data as [String:Any]!)
    }
    
    
}
