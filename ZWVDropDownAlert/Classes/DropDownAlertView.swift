//
//  DropDownAlertView.swift
//  ZWVDropDownAlert
//
//  Created by Jeremy Lawrence on 3/14/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

import UIKit

class DropDownAlertView: UIView {

    var titleLabel: UILabel
    var color: UIColor
    var textColor: UIColor
    
    override init(frame: CGRect) {
        var labelHeight: CGFloat = 30
        var labelFrame = CGRectMake(0, (frame.size.height-labelHeight)/2, frame.size.width, labelHeight)
        titleLabel = UILabel(frame: labelFrame)
        titleLabel.textAlignment = .Center
        color = UIColor.blueColor()
        textColor = UIColor.whiteColor()
        
        super.init(frame: frame)
        addSubview(titleLabel)
        backgroundColor = color
        titleLabel.textColor = textColor
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
