//
//  DataService.swift
//  Roll_Call
//
//  Created by Anthony Powell on 11/20/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService{
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("Users")
    private var _REF_COURSES = DB_BASE.child("Courses")
    private var _REF_ATTENDANCE = DB_BASE.child("Attendance")
    
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    var REF_COURSES: DatabaseReference{
        return _REF_COURSES
    }
    
    var REF_ATTENDANCE: DatabaseReference{
        return _REF_ATTENDANCE
    }
    
    func createUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
}
