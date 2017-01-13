//
//  CourseTableViewController.swift
//  Roll_Call
//
//  Created by Anthony Powell on 8/12/16.
//  Copyright © 2016 Anthony Powell. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellID")
        
        cell.textLabel?.text = "Test Data"
        return cell
    }
}
