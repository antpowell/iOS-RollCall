//
//  DropShadow.swift
//  Roll_Call
//
//  Created by Anthony Powell on 11/22/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import UIKit

class DropShadow: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.75)
        layer.shadowRadius = 1.7
        layer.shadowOpacity = 0.45
        layer.cornerRadius = 25
    }
    
}
