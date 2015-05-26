//
//  DirectoryNavigationViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/26/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit

class DirectoryNavigationViewController: UINavigationController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)

        let rootViewController = DirectoryViewController()
        self.setViewControllers([rootViewController], animated: false)

        let icon = UIImage(named: "DirectoryIcon")
        self.tabBarItem = UITabBarItem(title: nil, image: icon, selectedImage: icon)
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0)
    }

}
