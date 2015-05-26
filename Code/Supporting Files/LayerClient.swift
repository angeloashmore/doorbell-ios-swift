//
//  LayerClient.swift
//  Doorbell
//
//  Created by Angelo on 5/24/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import LayerKit
import Parse

public class LayerClient {

    // MARK: Constants
    private struct Constants {
        static let sharedClient = LayerClient()
    }


    // MARK: Class Properties
    public class var sharedClient: LayerClient {
        return Constants.sharedClient
    }


    // MARK: Instance Properties
    public var appID: NSUUID? {
        didSet {
            client = LYRClient(appID: appID)
        }
    }

    private var client: LYRClient?


    // MARK: Methods
    public func readyToInitialize() -> Bool {
        return client != nil && PFUser.currentUser() != nil
    }

    func initializeClient() -> Promise {
        return Promise { (resolve, reject) -> () in
            if self.readyToInitialize() {
                if let userID = PFUser.currentUser()?.objectId {
                    self.loginLayer(userID).then({ (_) -> () in
                        resolve(true)
                    })
                }
            } else {
                reject(true)
            }
        }
    }

    func loginLayer(userID: String) -> Promise {
        return self.connectToLayerServer().then({ (_) -> () in
            self.authenticateLayerWithUserID(userID)
        })
    }

    func connectToLayerServer() -> Promise {
        return Promise { (resolve, reject) -> () in
            self.client!.connectWithCompletion({ (success, error) -> Void in
                if !success {
                    reject(error)
                } else {
                    resolve(true)
                }
            })
        }
    }

    func authenticateLayerWithUserID(userID: String) -> Promise {
        return Promise { (resolve, reject) -> () in
            if let authenticatedUserID = self.client!.authenticatedUserID {
                // If the client is already authenticated
                if authenticatedUserID == userID {
                    // If the client is authenticated with the correct user
                    resolve(true)
                } else {
                    // If the client is NOT authenticated with the correct user
                    self.deauthenticateWithLayer().then({ (_) -> () in
                        self.authenticateWithLayerForTheFirstTime(userID)
                    }).then({ (_) -> () in
                        resolve(true)
                    })
                }
            } else {
                // If the client is NOT authenticated
                self.authenticateWithLayerForTheFirstTime(userID).then({ (_) -> () in
                    resolve(true)
                })
            }
        }
    }

    func deauthenticateWithLayer() -> Promise {
        return Promise { (resolve, reject) -> () in
            self.client!.deauthenticateWithCompletion({ (success, error) -> Void in
                if error == nil {
                    resolve(true)
                } else {
                    reject(error)
                }
            })
        }
    }

    func authenticateWithLayerForTheFirstTime(userID: String) -> Promise {
        return requestAuthenticationNonce()
        .then { (nonce) -> (AnyObject?) in
            self.generateToken((nonce as? String)!, userID: userID)

        }.then { (identityToken) -> (AnyObject?) in
            self.authenticateWithIdentityToken((identityToken as? String)!)

        }
    }

    func requestAuthenticationNonce() -> Promise {
        return Promise { (resolve, reject) -> () in
            self.client!.requestAuthenticationNonceWithCompletion({ (nonce, error) -> Void in
                if let nonce = nonce {
                    resolve(nonce)
                } else {
                    reject(error)
                }
            })
        }
    }

    func generateToken(nonce: String, userID: String) -> Promise {
        return Promise { (resolve, reject) -> () in
            let params = ["nonce": nonce, "userID": userID]
            PFCloud.callFunctionInBackground("generateToken", withParameters: params, block: { (object, error) -> Void in
                if error == nil {
                    resolve(object as? String)
                } else {
                    reject(error)
                }
            })
        }
    }

    func authenticateWithIdentityToken(identityToken: String) -> Promise {
        return Promise { (resolve, reject) -> () in
            self.client!.authenticateWithIdentityToken(identityToken, completion: { (authenticatedUserID, error) -> Void in
                if let authenticatedUserID = authenticatedUserID {
                    resolve(authenticatedUserID)
                } else {
                    reject(error)
                }
            })
        }
    }

}
