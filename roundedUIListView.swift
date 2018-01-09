//
//  roundedUIListView.swift
//  Roll_Call
//
//  Created by Anthony Powell on 1/5/18.
//  Copyright © 2018 Anthony Powell. All rights reserved.
//

import UIKit

class roundedUIListView: UITableView{
    private var radius = 10
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        layer.cornerRadius = CGFloat(radius)
        
    }
}
