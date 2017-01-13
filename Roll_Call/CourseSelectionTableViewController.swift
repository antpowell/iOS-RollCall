//
//  CourseSelectionTableViewController.swift
//  Roll_Call
//
//  Created by Anthony Powell on 1/11/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import UIKit
import Firebase


class CourseSelectionTableViewController: UITableViewController {
    
    var courseToPass: String!
    var lname: String!
    var tNum: String!
    var courseRef: FIRDatabaseReference!
    var _courses:[String]! = []
    
    let userDefault = UserDefaults.standard

    @IBOutlet var tv: UITableView!
    @IBOutlet var signInBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        cancleSignIn()
        configureDatabase()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return _courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseTextCell", for: indexPath)
        var dataFound = false

        if(!(_courses.isEmpty)){
            cell.textLabel?.text = _courses[indexPath.row]
            dataFound = true
        }else{
            cell.textLabel?.text = "Data not collected. Contact admin if problem persist"
        }
//        print(dataFound ? "Found courses" : "Data not collected")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCellSelected = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        let currentCourseSelected = currentCellSelected.textLabel!.text!
        
        if !currentCourseSelected.isEmpty{
            userDefault.set(currentCourseSelected, forKey: "courseKey")
            if let course = userDefault.string(forKey: "courseKey"){
                print("Course: \(course)")
                enableSignIn()
            }
            
        }else{
            cancleSignIn()
        }

    }

    func configureDatabase(){
        print("Fire 2nd")
        courseRef = FIRDatabase.database().reference().child("Courses").child("Codes")
        courseRef.observe(.value, with: { (s) in
                self._courses = s.value as! [String]
                print("Courses Found")
            
                self.tableView.reloadData()
    
        })
        
    }
    
    func cancleSignIn(){
        signInBtn.isEnabled = false
    }
    
    func enableSignIn(){
        signInBtn.isEnabled = true
    }
    deinit {
        courseRef.removeAllObservers()
    }

}
