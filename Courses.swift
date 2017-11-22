//
//  Courses.swift
//  Roll_Call
//
//  Created by Anthony Powell on 8/9/16.
//  Copyright © 2016 Anthony Powell. All rights reserved.
//

import UIKit
import Firebase

class Courses: NSObject {
    var couresDiction: NSArray?
    var foundCourses: Bool = false
    var courseNumber: String?
    var courseInstructor: String?
    var courseTime: String?
    var courseLocation: String?
    
    func getCourseFromDB(){
        
        let courseRef = Database.database().reference().child("Courses").child("Codes")
        courseRef.observe(.value, with: { (s) in
            if ((s.value as? [NSArray]) != nil){
                self.foundCourses = true
                self.couresDiction = s.value as? [NSArray] as NSArray?
                print(self.couresDiction!)
            }else{
                self.foundCourses = false
            }
        })
    }

}
