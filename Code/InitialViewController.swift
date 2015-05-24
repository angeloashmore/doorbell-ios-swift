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

class InitialViewController: UITabBarController {

    var layerClient: LYRClient!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if PFUser.currentUser() == nil {
            let authenticationStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let authenticationVC = authenticationStoryboard.instantiateInitialViewController() as! UIViewController
            self.presentViewController(authenticationVC, animated: true, completion: nil)
        } else {

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var controllers = Array<UIViewController>()

        let tabs = ["Chats", "Calendar", "Directory", "Ads", "Settings"]
        for name in tabs {
            let vc = instantiateViewControllerFromStoryboard(name)

            switch name {
            case "Chats":
                if let vc = vc as? ChatsViewController {
                    vc.layerClient = layerClient
                }
            default:
                break
            }

            controllers.append(vc)
        }

        self.viewControllers = controllers
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
