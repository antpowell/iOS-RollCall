//
//  CourseSelectionView.swift
//  Roll_Call
//
//  Created by Anthony Powell on 8/22/15.
//  Copyright (c) 2015 Anthony Powell. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CourseSelectionView: UIViewController, UIPickerViewAccessibilityDelegate, UIPickerViewDataSource {
    
    var _courses:[String]! = [""]
    let userDefault = UserDefaults.standard
    
    var courseToPass: String!
    var lname: String!
    var tNum: String!
    var ref: DatabaseReference!
    var courses: [DataSnapshot]! = []
    var keyboardOnScreen = false
    var placeholderImage = UIImage(named: "ic_account_circle")
    fileprivate var _refHandler: DatabaseHandle!
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var displayName = "Anonymous"
    
    // MARK: Outlets
    
    @IBOutlet var courseTable: UITableView!
    @IBOutlet weak var selectionPicker: UIPickerView!
    @IBOutlet weak var signInBtn: UIBarButtonItem!
    
    //@IBOutlet var signInBtn: UINavigationItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        cancleSignIn()
        configureDatabase()
        
        
        if let primeU = userDefault.string(forKey: "lNameKey"){
            if let primeT = userDefault.string(forKey: "tNumKey"){
                debugPrint("User data found. \(primeU): T\(primeT)")
                print("User data found. \(primeU): T\(primeT)")
            }
        }
        
        selectionPicker.dataSource = self
        selectionPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func configureDatabase() {
        ref = Database.database().reference()
        ref.child("Courses").child("Codes").observeSingleEvent(of: .value, with: {(s) in
            self._courses = s.value as! [String]
            print(self._courses);
            sleep(2)
            })
        
//        _refHandler = ref.child("Courses").child("Codes").observe(.childAdded){(snapshot:FIRDataSnapshot) in
//            self.courses.append(snapshot)
//
//            debugPrint(self.courses)
//        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _courses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _courses[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getSelection()
    }
    
    func getSelection(){
        let courseSelected = _courses[selectionPicker.selectedRow(inComponent: 0)]
        courseToPass = courseSelected
        if (courseToPass != "  " || courseToPass != nil) {
            userDefault.set(courseSelected, forKey: "courseKey")
            if let primeC = userDefault.string(forKey: "courseKey"){
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
        signInBtn.isEnabled = false
    }
    
    func enableSignIn(){
        signInBtn.isEnabled = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Code to pass to the next View
        
    }
}
