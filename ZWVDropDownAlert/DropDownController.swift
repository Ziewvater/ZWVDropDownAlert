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
    var attachmentBehavior: UIAttachmentBehavior?
    
    var presentedAlert: UIView?
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
            presentedAlert = view
            
            view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "pan:"))
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tap:"))
                        
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
}

// MARK: - UICollisionBehaviorDelegate
extension DropDownController: UICollisionBehaviorDelegate {
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        if removing {
            collisionBehavior?.removeItem(item)
            gravityBehavior?.removeItem(item)
            completeAlertRemoval()
        }
    }
}

// MARK: Pan and tap gesture methods
extension DropDownController {
    
    // MARK: Tap
    
    func tap(tapGesture: UITapGestureRecognizer) {
        removeAlert()
    }
    
    // MARK: Pan
    
    func pan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .Possible: break
        case .Began:
            startPanInteraction(panGesture)
        case .Changed:
            moveAlertForPan(panGesture)
        case .Ended:
            finalizePan()
        case .Cancelled:
            finalizePan()
        case .Failed: break
        }
    }
    
    func startPanInteraction(panGesture: UIPanGestureRecognizer) {
        var location = panGesture.locationInView(window)
        if let alert = presentedAlert {
            // Attach alert to touch
            var anchor = CGPoint(x: CGRectGetMidX(window!.bounds), y: location.y)
            var attachment = UIAttachmentBehavior(item: alert, attachedToAnchor: anchor)
            dynamicAnimator?.addBehavior(attachment)
            
            // Remove gravity so it's just the attachment and collision controlling the alert
            if let gravity = gravityBehavior {
                dynamicAnimator?.removeBehavior(gravity)
            }
            attachmentBehavior = attachment
        }
    }
    
    func moveAlertForPan(panGesture: UIPanGestureRecognizer) {
        var location = panGesture.locationInView(window)
        if let attachment = attachmentBehavior {
            var anchor = CGPoint(x: CGRectGetMidX(window!.bounds), y: location.y)
            attachment.anchorPoint = anchor
        }
    }
    
    func finalizePan() {
        if let attachment = attachmentBehavior {
            dynamicAnimator?.removeBehavior(attachment)
        }
        
        if let gravity = gravityBehavior {
            dynamicAnimator?.addBehavior(gravity)
        }
        removeAlert()
    }
}
