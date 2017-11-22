//
//  hollowRoundedButton.swift
//  Roll_Call
//
//  Created by Anthony Powell on 11/22/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import UIKit

class hollowRoundedButton: UIButton {
    private var radius = 7
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        layer.cornerRadius = CGFloat(radius)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
}
