//
//  ChatsViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/23/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import LayerKit
import PKHUD
import Parse

class ChatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure Layer.
        LayerClient.sharedClient.initializeClient()
    }

//    func loginLayer() {
//        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
//        PKHUD.sharedHUD.show()
//
//        // Connect to Layer.
//        layerClient.connectWithCompletion { (success, error) in
//            println("success: \(success)")
//            println("error: \(error)")
//            if !success {
//                println("Failed to connect to Layer")
//            } else {
//                let user = PFUser.currentUser()
//
//                if let userID = user?.objectId {
//                    self.authenticateLayerWithUserID(userID) { (success, error) in
//                        if !success {
//                            PKHUD.sharedHUD.hide()
//                            println("Failed Authenticating Layer Client with error: \(error)")
//                        } else {
//                            PKHUD.sharedHUD.hide()
//                            self.presentConversationListViewController()
//                        }
//                    }
//                }
//
//            }
//        }
//    }
//
//    func authenticateLayerWithUserID(userID: String, completion: (success: Bool, error: NSError?) -> Void) {
//        // Check to see if layerClient is already authenticated.
//        if let authenticatedUserID = layerClient.authenticatedUserID {
//            if authenticatedUserID == userID {
//                println("Layer Authenticated as User \(authenticatedUserID)")
//                completion(success: true, error: nil)
//            } else {
//                layerClient.deauthenticateWithCompletion({ (success, error) -> Void in
//                    if error == nil {
//                        self.authenticationTokenWithUserID(userID, completion: { (success, error) -> Void in
//                            completion(success: success, error: error)
//                        })
//                    } else {
//                        completion(success: false, error: error)
//                    }
//                })
//            }
//        } else {
//            authenticationTokenWithUserID(userID, completion: { (success, error) -> Void in
//                completion(success: success, error: error)
//            })
//        }
//
//        return
//    }
//
//    func authenticationTokenWithUserID(userID: String, completion: (success: Bool, error: NSError?) -> Void) {
//        /*
//        * 1. Request an authentication Nonce from Layer
//        */
//        layerClient.requestAuthenticationNonceWithCompletion({(nonce, error) in
//            if let nonce = nonce {
//                println("nonce \(nonce)")
//
//                PFCloud.callFunctionInBackground("generateToken", withParameters: ["nonce": nonce, "userID": userID], block: { (object, error) -> Void in
//                    if error == nil {
//                        let identityToken = object as? String
//                        self.layerClient.authenticateWithIdentityToken(identityToken, completion: { (authenticatedUserID, error) -> Void in
//                            if let authenticatedUserID = authenticatedUserID {
//                                println("Layer Authenticated as User: \(authenticatedUserID)")
//                                completion(success: true, error: nil)
//                            } else {
//                                completion(success: false, error: error)
//                            }
//                        })
//                    } else {
//                        println("Parse Cloud function failed to be called to generate token with error: \(error)")
//                    }
//                })
//            } else {
//                completion(success: false, error: error)
//            }
//
//            return
//        })
//    }
//
//    func presentConversationListViewController() {
//        println("this is where we would show the list")
//    }

}
