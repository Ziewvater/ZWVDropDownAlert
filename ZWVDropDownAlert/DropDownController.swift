//
//  DropDownController.swift
//  ZWVDropDownAlert
//
//  Created by Jeremy Lawrence on 3/18/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

import UIKit

class DropDownController: NSObject {
    
    var window: UIWindow?
    
    func showAlert() {
        var screen = UIScreen.mainScreen()
        var windowFrame = CGRectMake(0, 0, CGRectGetWidth(screen.bounds), 128)
        var window = UIWindow(frame: windowFrame)
        
        var alert = DropDownAlertView(frame: window.bounds)
        alert.titleLabel.text = "Oh yeah here we go again"
        window.addSubview(alert)
        window.windowLevel = UIWindowLevelStatusBar
        self.window = window
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            window.hidden = false
        })
    }
    
    func removeAlert() {
        window?.hidden = true
        window = nil
    }
}
