//
//  CalendarNavigationViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/26/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit

class CalendarNavigationViewController: UINavigationController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)

        let rootViewController = CalendarViewController()
        self.setViewControllers([rootViewController], animated: false)

        let icon = UIImage(named: "CalendarIcon")
        self.tabBarItem = UITabBarItem(title: nil, image: icon, selectedImage: icon)
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0)
    }

}