//
//  ViewController.swift
//  ZWVDropDownAlert
//
//  Created by Jeremy Lawrence on 3/14/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var alertController = DropDownController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        if let alertWindow = alertController.window {
            alertController.removeAlert()
        } else {
            alertController.showAlert()
        }
    }
    
}

