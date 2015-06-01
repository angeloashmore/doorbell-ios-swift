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

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        let controllerNames = ["Chats", "Calendar", "Directory", "Ads", "Settings"]
        let controllers = controllerNames.map { self.resolveController($0) }

        self.viewControllers = controllers
    }

    func resolveController(name: String) -> UIViewController {
        var storyboard: UIStoryboard
        var controller: UIViewController

        switch name {
        case "Chats":
            controller = ChatsNavigationViewController()
        default:
            storyboard = UIStoryboard(name: name, bundle: nil)
            controller = storyboard.instantiateInitialViewController() as! UIViewController
        }

        let icon = UIImage(named: "\(name)Icon")
        controller.tabBarItem = UITabBarItem(title: nil, image: icon, selectedImage: icon)
        controller.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0)

        return controller
    }

}
