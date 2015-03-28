//
//  DropDownController.swift
//  ZWVDropDownAlert
//
//  Created by Jeremy Lawrence on 3/18/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

import UIKit

let LilTinyBuffer: CGFloat = 10

class DropDownController: NSObject, UICollisionBehaviorDelegate {
    
    var window: UIWindow?
    var dynamicAnimator: UIDynamicAnimator?
    var gravityBehavior: UIGravityBehavior?
    var collisionBehavior: UICollisionBehavior?
    
    var removing = false
    
    // MARK: Window lifecycle
    
    func windowDidBecomeVisible(notification: NSNotification) {
        if let alertWindow = window {
            removing = false
            
            // Create alert view
            var view = UIView(frame: alertWindow.bounds)
            view.backgroundColor = UIColor.redColor()
            var start = view.frame
            start.origin = CGPoint(x: start.origin.x, y: start.origin.y - start.size.height)
            view.frame = start
            alertWindow.addSubview(view)
            
            collisionBehavior?.addItem(view)
            gravityBehavior?.addItem(view)
        }
    }
    
    // MARK: - Public methods
    
    func showAlert(alertView: UIView) {
        var screen = UIScreen.mainScreen()
        var windowFrame = CGRectMake(0, 0, CGRectGetWidth(screen.bounds), 128)
        var window = UIWindow(frame: windowFrame)
        
        window.windowLevel = UIWindowLevelStatusBar
        self.window = window
        
        dynamicAnimator = UIDynamicAnimator(referenceView: window)
        
        // Collision behavior that stops alert at Nav bar height
        var collision = UICollisionBehavior()
        collision.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsets(top: -(CGRectGetHeight(window.frame)+LilTinyBuffer), left: 0, bottom: 0, right: 0))
        collision.collisionDelegate = self
        dynamicAnimator?.addBehavior(collision)
        collisionBehavior = collision
        
        var gravity = UIGravityBehavior()
        gravity.gravityDirection = CGVector(dx: 0, dy: 1)
        dynamicAnimator?.addBehavior(gravity)
        gravityBehavior = gravity
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "windowDidBecomeVisible:", name: UIWindowDidBecomeVisibleNotification, object: window)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            window.hidden = false
        })
    }
    
    func removeAlert() {
        if let gravity = gravityBehavior {
            gravity.gravityDirection = CGVector(dx: 0, dy: -2)
            removing = true
        }
    }
    
    // MARK: - Private methods
    
    private func completeAlertRemoval() {
        window?.hidden = true
        window = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - UICollisionBehaviorDelegate
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        if removing {
            collisionBehavior?.removeItem(item)
            gravityBehavior?.removeItem(item)
            completeAlertRemoval()
        }
    }
}
