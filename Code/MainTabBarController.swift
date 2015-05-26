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

    private let tabs = ["Chats", "Calendar", "Directory", "Ads", "Settings"]

    override func viewDidLoad() {
        let controllers = buildControllersArray()
        self.viewControllers = controllers
    }

    private func buildControllersArray() -> [UIViewController] {
        var controllers: [UIViewController] = []

        for name in tabs {
            let vc = instantiateViewControllerFromStoryboard(name)
            controllers.append(vc)
        }

        return controllers
    }

    private func instantiateViewControllerFromStoryboard(name: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UIViewController
        let icon = UIImage(named: "\(name)Icon")

        vc.tabBarItem = UITabBarItem(title: nil, image: icon, selectedImage: icon)
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0)

        return vc
    }
    
}
