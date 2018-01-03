//
//  AlertService.swift
//  Roll_Call
//
//  Created by Anthony Powell on 12/30/17.
//  Copyright © 2017 Anthony Powell. All rights reserved.
//

import Foundation
import UIKit

class Alert{
    var title: String!
    var message: String!
    var hasCancelAction: Bool!
    var cancelTitle: String?
    var hasOkAction: Bool!
    
    required init(title: String, message: String, hasCancelAction: Bool, cancelTitle: String?, hasOkAction: Bool!){
        self.title = title
        self.message = message
        if(hasCancelAction){
            self.cancelTitle = cancelTitle
        }
        self.hasCancelAction = hasCancelAction
    }
    
    func createAlert(){
        let alert = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
        if hasCancelAction{
            let cancleAction = UIAlertAction(title: self.cancelTitle, style: .cancel, handler: { (action) in
                <#code#>
            })
        }
    }
    
    let alert = UIAlertController(title: "You are about to sign the roll.", message: "Your current data consist of: \(getUserData())", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        let innerAlert = UIAlertController(title: "Canceling", message: "You have decided to cancel signing the roll.", preferredStyle: .alert)
        let innerOKAction = UIAlertAction(title: "OK", style: .default){ action -> Void in
        }
        innerAlert.addAction(innerOKAction)
        self.present(innerAlert, animated: true, completion: nil)
        print("You have decided to cancel signing the roll.")
}
