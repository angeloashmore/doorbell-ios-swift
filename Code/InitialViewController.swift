//
//  InitialViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/26/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import PKHUD

class InitialViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if PFUser.currentUser() == nil {
            let authenticationStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let authenticationVC = authenticationStoryboard.instantiateInitialViewController() as! UIViewController
            self.presentViewController(authenticationVC, animated: true, completion: nil)
        } else {
            initializeLayerClient()
        }
    }

    func initializeLayerClient() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()

        LayerClient.sharedClient.initializeClient()

        .then { (_) -> () in
            PKHUD.sharedHUD.hide()
            
            let controller = MainTabBarController()
            self.presentViewController(controller, animated: true, completion: nil)

        }.catch { (error) -> () in
            PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Error", image: PKHUDAssets.crossImage)
            PKHUD.sharedHUD.hide(afterDelay: 1.0)

        }
    }

}
