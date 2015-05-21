//
//  AppDelegate.swift
//  Doorbell
//
//  Created by Angelo on 5/20/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Bolts
//import LayerKit
import Parse
import ParseUI

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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        // Configure Parse.
        Parse.enableLocalDatastore()
        Parse.setApplicationId(ExternalKeys.Parse.AppID, clientKey: ExternalKeys.Parse.ClientKey)
        PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)

//        let layerClient: LYRClient = LYRClient(appID: ExternalKeys.Layer.AppID)

//        let controller: ViewController = ViewController()
//        controller.layerClient = layerClient

        return true
    }

}

