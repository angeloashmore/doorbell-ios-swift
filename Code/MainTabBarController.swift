//
//  ViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/23/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import LayerKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        self.viewControllers = [
            ChatsNavigationViewController(),
            CalendarNavigationViewController(),
            DirectoryNavigationViewController(),
            AdsNavigationViewController(),
            SettingsNavigationViewController()
        ]
    }

}
