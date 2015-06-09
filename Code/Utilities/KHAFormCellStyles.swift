//
//  KHAFormButtonCell.swift
//  Doorbell
//
//  Created by Angelo on 6/8/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import KHAForm

extension KHAFormCell {
    enum StyleType {
        case ButtonAction
        case ButtonActionDisclosure
        case ButtonDisclosure
    }

    func addStyle(style: StyleType) {
        switch style {
        case .ButtonAction:
            button.setTitleColor(UIColor(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1.0), forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(17)
            button.contentHorizontalAlignment = .Left
            button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)

        case .ButtonActionDisclosure:
            button.setTitleColor(UIColor(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1.0), forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(17)
            button.contentHorizontalAlignment = .Left
            button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)
            accessoryType = .DisclosureIndicator

        case .ButtonDisclosure:
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(17)
            button.contentHorizontalAlignment = .Left
            button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)
            accessoryType = .DisclosureIndicator
        }
    }
}