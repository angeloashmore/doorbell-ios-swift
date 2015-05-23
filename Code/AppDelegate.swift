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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Configure Parse.
        Parse.enableLocalDatastore()
        Parse.setApplicationId(ExternalKeys.Parse.AppID, clientKey: ExternalKeys.Parse.ClientKey)
        PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser: true)

        // Configure Layer.
        let appID = NSUUID(UUIDString: ExternalKeys.Layer.AppID)
        let layerClient = LYRClient(appID: appID)

        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()

        // Load the initial form from Storyboard.
        let storyboard = UIStoryboard.init(name: "Authentication", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as? UIViewController
        self.window!.rootViewController = vc
        self.window!.makeKeyAndVisible()

        return true
    }

}

