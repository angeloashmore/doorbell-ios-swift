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
import ParsePromiseKitSwift

class InitialViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let currentUser = PFUser.currentUser() {
            initializeLayerClient()
        } else {
            let authenticationStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let authenticationVC = authenticationStoryboard.instantiateInitialViewController() as! UIViewController
            self.presentViewController(authenticationVC, animated: true, completion: nil)
        }
    }

    func initializeLayerClient() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()

        LayerClient.sharedClient.initializeClient()
            .then { _ -> Void in
                PKHUD.sharedHUD.hide()
                
                let controller = TabBarController()
                self.presentViewController(controller, animated: true, completion: nil)

            }.catch(policy: .AllErrors) { (error) -> Void in
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Error", image: PKHUDAssets.crossImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)

            }
    }

}
