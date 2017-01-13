//
//  CourseSelectionViewController.swift
//  Roll_Call
//
//  Created by Anthony Powell on 8/6/16.
//  Copyright © 2016 Anthony Powell. All rights reserved.
//

import UIKit
import Firebase

class CourseSelectionViewController: UIViewController, UITableViewDelegate {
    var c = Courses()
    //label to select course
    let courseSelectionLabel: UILabel = {
        let l = UILabel()
        l.text = "Choose course from below."
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = NSTextAlignment.center
        l.textAlignment = .center
        return l
    }()
    let listViewContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    let courseTableView : UITableView = {
        let tv = UITableView()
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellID")
        cell.textLabel?.text = "Test Text"
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.numberOfRows(inSection: 5)
        tv.layer.cornerRadius = 5
        tv.addSubview(cell)
        return tv
    }()
    let courseTableCell : UITableViewCell = {
        let cell = UITableViewCell()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.textLabel!.text = "Test"
        return cell
    }()
    //Listview for course
    //populate list view with courses and imgs
    //course images
    //course labels
    //handle listview click
    //get and pass value clicked to next view


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 255, alpha: 1)
        
        //Logout button in navigaiton
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTouchedHandler))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next Page", style: .plain, target: self, action: #selector(nextPageHandler))
        
        view.addSubview(courseSelectionLabel)
        courseSelectionLabelConstrants()
        
        view.addSubview(courseTableView)
        courseTableViewConstraints()
        
        c.getCourseFromDB()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            logoutTouchedHandler()
        } else {
            isUserLoggedIn()

        }

    }

    func logoutTouchedHandler() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }

        present(LoginRegistrationViewController(), animated: true, completion: nil)
    }
    
    func nextPageHandler(){
        present(CourseSelectionTableViewController(), animated: true, completion: nil)
    }

    func isUserLoggedIn() {
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid

        if uid != nil {
            let uidRef = FIRDatabase.database().reference().child("FBTester").child("IDs").child(uid!)
            let usersRef = FIRDatabase.database().reference().child("FBTester").child("Users")
            uidRef.observe(.value, with: {
                (snapshot) in
                let dictionary = snapshot.value as? [String:AnyObject]
                print("DICTION:.... \(dictionary)")
                let tNumber = dictionary!["T Number"] as? String
                let userRef = usersRef.child(tNumber!)
                userRef.observe(.value, with: {
                    (s) in
                    let diction = s.value as? [String:AnyObject]
                    //Place user lastname and tnumber as title of navigation
                    self.navigationItem.title = diction!["Name"] as? String
                })
            })

        }
    }
    func courseSelectionLabelConstrants(){
        courseSelectionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        courseSelectionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        courseSelectionLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -48).isActive = true
        courseSelectionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    func courseTableViewConstraints(){
        let v = courseTableView
        v.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        v.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        v.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -36).isActive = true
        v.topAnchor.constraint(equalTo: courseSelectionLabel.bottomAnchor).isActive = true
        v.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return c.couresDiction!.count
    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
////        let cell = self.tableView(courseTableView, numberOfRowsInSection: 1)
//        return null
//    }
}
