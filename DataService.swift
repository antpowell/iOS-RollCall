//
//  DataService.swift
//  Roll_Call
//
//  Created by Anthony Powell on 11/20/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//
//
//This service will handle all events dealing with the realtime database

import Foundation
import Firebase

let DB_BASE = Database.database().reference()


class DataService{
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("Users")
    private var _REF_COURSES = DB_BASE.child("Courses")
    private var _REF_ATTENDANCE = DB_BASE.child("Attendance")
    private var _COURSE_CODES: [String] = []
    
    //    init(){
    //        self.fetchCourses { (courses) in
    //            self._COURSE_CODES = (courses["Codes"])!
    //        }
    //    }
    
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
    
    var COURSE_CODES: [String] {
        return _COURSE_CODES
    }
    
    func createUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    func fetchCourses(completion: @escaping ([String: Any]) -> ()){
        REF_COURSES.observeSingleEvent(of: .value, with: { (s) in
            print("Getting courses")
            let _courses = s.value! as? NSDictionary
//            let codes = _courses!["Codes"] as? [String]
//            let images = _courses!["Images"] as? [String]
            completion(_courses! as! [String: Any])
            //            print(_courses!)
        }) { (err) in
            print(err.localizedDescription)
        }
    }
    
    func fetchUser(user:User, completion: @escaping (Users) -> ()){
        self.REF_USERS.child(user.uid).observeSingleEvent(of: .value, with: { (s) in
            let userData = s.value as! [String: Any]
            Users.public_instance.formateUser(userSnapshot: userData, completion: { (user) in
                print(user.description)
                completion(user)
            })
        })
    }
    
    func signStudentIn(course:String, pod: String, completion: @escaping (Bool, String?) -> ()){
//        REF_ATTENDANCE.child(course).setValue(OneTimeSignature(course: course, password_of_the_day: pod).formateSignature()){
//            (err, ref) -> Void in
//            if err != nil {
//                print("error in signing student in: \(String(describing: err))")
//                completion(false, "\(String(describing: err))")
//                return
//            }else {
//                completion(true, nil)
//                return
//            }
//
//        }
        
        //// USE THIS FORM FIND CORRECTION FOR THIS TO WORK
//        REF_ATTENDANCE.child(course).child(date).child(_tNum).setValue(OneTimeSignature(course: course, password_of_the_day: pod).formateSignature())
        //// ------------------------><--------------------------
    }
    
    func storeUserDataInDB(user: User, userStored: @escaping (Bool) -> ()){
        self.REF_USERS.child(user.uid).setValue(Users.public_instance.getUser()){(err, ref) -> Void in
            if err == nil {
                // no error
                userStored(true)
            }else{
                // error thrown
                print(err?.localizedDescription)
                userStored(false)
            }
        }
    }
}
