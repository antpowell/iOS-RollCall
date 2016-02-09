//
//  MessageComposer.swift
//  Roll_Call
//
//  Created by Anthony Powell on 2/1/16.
//  Copyright © 2016 Anthony Powell. All rights reserved.
//

import Foundation
import MessageUI

//let drNum = ["8327418926"]

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate{
    
    func  canSendText() -> Bool{
        return MFMessageComposeViewController.canSendText()
    }
    
    func configureMessageComposeViewController(drNum: String, messageBody: String) -> MFMessageComposeViewController{
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        messageComposeVC.recipients = [drNum]
        messageComposeVC.body = messageBody
        return messageComposeVC
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
