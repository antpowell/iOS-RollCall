//
//  TableViewController.swift
//  Roll_Call
//
//  Created by Anthony Powell on 8/11/16.
//  Copyright © 2016 Anthony Powell. All rights reserved.
//

import UIKit
import Firebase


class TableViewController: UIViewController {

    @IBOutlet var courseListTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let userRef = FIRDatabase.database().reference().child("FBTester").child("Users")
        print(userRef)
    }

}
