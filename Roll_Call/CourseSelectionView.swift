//
//  CourseSelectionView.swift
//  Roll_Call
//
//  Created by Anthony Powell on 8/22/15.
//  Copyright (c) 2015 Anthony Powell. All rights reserved.
//

import UIKit

class CourseSelectionView: UIViewController, UIPickerViewAccessibilityDelegate, UIPickerViewDataSource {
    
    let courses = ["  ","CS124", "CS116"]
    let userDefault = NSUserDefaults.standardUserDefaults()
    
    var courseToPass: String!
    var lname: String!
    var tNum: String!
    
    
    @IBOutlet weak var selectionPicker: UIPickerView!
    
    @IBOutlet weak var signInBtn: UIBarButtonItem!
    
    //@IBOutlet var signInBtn: UINavigationItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let primeU = userDefault.stringForKey("lNameKey"){
            if let primeT = userDefault.stringForKey("tNumKey"){
                print("User data found. \(primeU): T\(primeT)")
            }
        }
        
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        cancleSignIn()
      
        selectionPicker.dataSource = self
        selectionPicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courses.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return courses[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getSelection()
    }
    
    func getSelection(){
        let courseSelected = courses[selectionPicker.selectedRowInComponent(0)]
        courseToPass = courseSelected
        if (courseToPass != "  " || courseToPass != nil) {
            userDefault.setObject(courseSelected, forKey: "courseKey")
            if let primeC = userDefault.stringForKey("courseKey"){
                print("Course: \(primeC)")
            }
            //regDoc["Course"] = courseSelected
            enableSignIn()
        }
        if (courseToPass == "  ") {
            cancleSignIn()
        }
    }
    
    func cancleSignIn(){
        signInBtn.enabled = false
    }
    
    func enableSignIn(){
        signInBtn.enabled = true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Code to pass to the next View
        
    }
}
