//
//  AppDelegate.swift
//  Doorbell
//
//  Created by Angelo on 5/20/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import LayerKit

struct ExternalKeys {
    struct Layer {
        static let AppID = "c8601d32-d1de-11e4-91f6-e08ce8001374"
    }
    struct Parse {
        static let AppID = "DJlID2KyyrJHkOCqrqUmnmZt1lfuYJLFZ5gcuXeq"
        static let ClientKey = "wvrymh4vqU4sa2Hje09KT3wQBjhdt1AX6hjm0zuV"
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LYRClientDelegate {

    var window: UIWindow?
    var layerClient: LYRClient!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Configure Parse.
        Parse.enableLocalDatastore()
        Parse.setApplicationId(ExternalKeys.Parse.AppID, clientKey: ExternalKeys.Parse.ClientKey)
        PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)

        // Configure Layer.
        let appID = NSUUID(UUIDString: ExternalKeys.Layer.AppID)
        let layerClient = LYRClient(appID: appID)
        layerClient.delegate = self

        // Log out the current user.
//        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
//            if error == nil {
//                println("successfully logged out")
//            } else {
//                println("error logging out")
//                println(error)
//            }
//        }

        // Load InitialViewController.
        let initialViewController = InitialViewController()
        initialViewController.layerClient = layerClient

        window?.rootViewController = initialViewController

        return true
    }

    func layerClient(client: LYRClient!, didReceiveAuthenticationChallengeWithNonce nonce: String!) {
        println("Layer Client did recieve authentication challenge with nonce: \(nonce)") 
    }

}

