//
//  CourseSelectionVC.swift
//  Roll_Call
//
//  Created by Anthony Powell on 12/5/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CourseSelectionVC: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource{
    
    @IBOutlet var courseSearchBar: UISearchBar!
    @IBOutlet var courseTableView: UITableView!
    
    var _courseCodes:[String]! = []
    var _filteredCourseCodes:[String]! = []
    var isUserSearching = false
    
    let userDefault = UserDefaults.standard
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseTableView.delegate = self
        courseTableView.dataSource = self
        setupSearchBar()
        
        DataService.instance.fetchCourses{(courses) in
            self._courseCodes = courses["Codes"] as! [String]
            self.courseTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isUserSearching ? _filteredCourseCodes.count : _courseCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "course_code_cell", for: indexPath)
        
//        let cell = UITableViewCell()
        if isUserSearching{
            cell.textLabel?.text = _filteredCourseCodes[indexPath.row]
        }else{
            if(!(_courseCodes.isEmpty)){
                cell.textLabel?.text = _courseCodes[indexPath.row]
            }else{
                cell.textLabel?.text = "Data not collected.\nContact admit if problem persist"
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCellSelected = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        let currentCourseSelected = currentCellSelected.textLabel!.text!
        
        if !currentCourseSelected.isEmpty{
            userDefault.set(currentCourseSelected, forKey: "courseKey")
            if let course = userDefault.string(forKey: "courseKey"){
                //sanity check on course
                print("Course: \(course)")
                print("code from user defaults: \(String(describing: userDefault.string(forKey: "courseKey")!))")
                
                let signRollVC = self.storyboard?.instantiateViewController(withIdentifier: "SignWIthSignatureVC")
                self.present(signRollVC!, animated: true, completion: nil)
                
            }else{
                print("Error getting selected course")
            }
        }else{
            print("Error: empty course selected")
        }
    }
    
    
    func setupSearchBar(){
        courseSearchBar.showsCancelButton = false
        courseSearchBar.placeholder = "Search CourseCode Here"
        courseSearchBar.delegate = self
    }
    
    func filterCourses(searchText: String, scope: String = "All"){
        _filteredCourseCodes = _courseCodes.filter{ course in
            return course.contains(searchText.lowercased())
        }
        courseTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        _filteredCourseCodes = _courseCodes.filter({ (courses: String) -> Bool in
            return courses.lowercased().range(of: searchText.lowercased()) != nil
        })
        if searchText.isEmpty{
            isUserSearching = false
            self.courseTableView.reloadData()
        }else{
            isUserSearching = true
            self.courseTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isUserSearching = true
        searchBar.endEditing(true)
        self.courseTableView.reloadData()
    }
    
    
    
//    func sendRollToDB(){
//        let encodedStudent = userDefault.data(forKey: "_student")
//        let unarchivedStudent = NSKeyedUnarchiver.unarchiveObject(with: encodedStudent!) as? Users
//        
//        
//        attendanceRef.setValue(Signature(
//            course: (userDefault.string(forKey: "courseKey"))!,
//            user: unarchivedStudent!, password: enteredPass.text!).getFormattedSignature())
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
