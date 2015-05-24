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

        // Create UITabBarController.
        let tabBarController = UITabBarController()

        let chatsStoryboard = UIStoryboard(name: "Chats", bundle: nil)
        let chatsVC = chatsStoryboard.instantiateInitialViewController() as! UIViewController
        let chatsIcon = UIImage(named: "ChatsIcon")
        chatsVC.tabBarItem = UITabBarItem(title: nil, image: chatsIcon, selectedImage: chatsIcon)
        chatsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0)

        let calendarStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
        let calendarVC = calendarStoryboard.instantiateInitialViewController() as! UIViewController
        let calendarIcon = UIImage(named: "CalendarIcon")
        calendarVC.tabBarItem = UITabBarItem(title: nil, image: calendarIcon, selectedImage: calendarIcon)
        calendarVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0)

        let directoryStoryboard = UIStoryboard(name: "Directory", bundle: nil)
        let directoryVC = directoryStoryboard.instantiateInitialViewController() as! UIViewController
        let directoryIcon = UIImage(named: "DirectoryIcon")
        directoryVC.tabBarItem = UITabBarItem(title: nil, image: directoryIcon, selectedImage: directoryIcon)
        directoryVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0)

        let adsStoryboard = UIStoryboard(name: "Ads", bundle: nil)
        let adsVC = adsStoryboard.instantiateInitialViewController() as! UIViewController
        let adsIcon = UIImage(named: "AdsIcon")
        adsVC.tabBarItem = UITabBarItem(title: nil, image: adsIcon, selectedImage: adsIcon)
        adsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0)

        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsVC = settingsStoryboard.instantiateInitialViewController() as! UIViewController
        let settingsIcon = UIImage(named: "SettingsIcon")
        settingsVC.tabBarItem = UITabBarItem(title: nil, image: settingsIcon, selectedImage: settingsIcon)
        settingsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0)

        let controllers = [chatsVC, calendarVC, directoryVC, adsVC, settingsVC]
        tabBarController.viewControllers = controllers

        window?.rootViewController = tabBarController

//        // Override point for customization after application launch.
//        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
//        self.window!.backgroundColor = UIColor.whiteColor()
//
//        // Load the initial form from Storyboard.
//        let storyboard = UIStoryboard.init(name: "Authentication", bundle: nil)
//        let vc = storyboard.instantiateInitialViewController() as? UIViewController
//        self.window!.rootViewController = vc
//        self.window!.makeKeyAndVisible()

        return true
    }

}

