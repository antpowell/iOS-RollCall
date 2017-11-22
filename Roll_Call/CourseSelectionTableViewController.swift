//
//  CourseSelectionTableViewController.swift
//  Roll_Call
//
//  Created by Anthony Powell on 1/11/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import UIKit
import Firebase


class CourseSelectionTableViewController: UITableViewController, UISearchBarDelegate {
    
    var courseToPass: String!
    var lname: String!
    var tNum: String!
    var courseRef: DatabaseReference!
    var _courses:[String]! = []
    var _filteredCourses:[String]! = []
    var isUserSearching = false
    
    let userDefault = UserDefaults.standard
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet var courseSearchBar: UISearchBar!
    @IBOutlet var tv: UITableView!
    @IBOutlet var signInBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        cancleSignIn()
        setupSearchBar()
        configureDatabase()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        return isUserSearching ? _filteredCourses.count : _courses.count
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseTextCell", for: indexPath)
        if isUserSearching{
            cell.textLabel?.text = _filteredCourses[indexPath.row]
        }else{
            if(!(_courses.isEmpty)){
                cell.textLabel?.text = _courses[indexPath.row]
                
            }else{
                cell.textLabel?.text = "Data not collected. Contact admin if problem persist"
            }
        }

        

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
        courseRef = Database.database().reference().child("Courses").child("Codes")
        courseRef.observe(.value, with: { (s) in
                self._courses = s.value as! [String]
                print("Courses Found")
            
                self.tableView.reloadData()
    
        })
        
    }
    func setupSearchBar(){
        courseSearchBar.showsCancelButton = false
        courseSearchBar.placeholder = "Search courses here"
        courseSearchBar.delegate = self
        
    }
    
    func filterCourses(searchText: String, scope: String = "All"){
        _filteredCourses = _courses.filter{ course in
            return course.contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        _filteredCourses = _courses.filter({ (courses: String) -> Bool in
            return courses.lowercased().range(of: searchText.lowercased()) != nil
        })
        if searchText.isEmpty{
            isUserSearching = false
            self.tableView.reloadData()
        }else{
            isUserSearching = true
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isUserSearching = true
        searchBar.endEditing(true)
        self.tableView.reloadData()
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
