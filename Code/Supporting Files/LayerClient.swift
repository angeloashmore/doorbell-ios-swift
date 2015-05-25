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

    public func initializeClient() {
        if readyToInitialize() {
            loginLayer()
        } else {
            println("Not ready to initialize!")
        }
    }

    func loginLayer() {
        connectToLayerServer().then { (_) -> () in
            let user = PFUser.currentUser()

            if let userID = user?.objectId {
                self.authenticateLayerWithUserID(userID).then({ (authenticatedUserID) -> () in
                    println("Authenticated with userID: \(authenticatedUserID)")
                })
            }
        }.catch { (error) -> () in
            println(error)
        }
    }

    func connectToLayerServer() -> Deferred {
        let deferred = Deferred()

        client!.connectWithCompletion { (success, error) -> Void in
            if !success {
                deferred.reject(error)
            } else {
                deferred.resolve(true)
            }
        }

        return deferred
    }

    func authenticateLayerWithUserID(userID: String) -> Deferred {
        let deferred = Deferred()

        if let authenticatedUserID = client!.authenticatedUserID {
            if authenticatedUserID == userID {
                deferred.resolve(authenticatedUserID)
            } else {
                deauthenticateWithLayer()
                    .then({ (_) -> () in
                        authenticateWithLayerForTheFirstTime(userID)
                    })
            }
        } else {
            return authenticateWithLayerForTheFirstTime(userID)
        }

        return deferred
    }

    func deauthenticateWithLayer() -> Deferred {
        let deferred = Deferred()

        client!.deauthenticateWithCompletion { (success, error) -> Void in
            if error == nil {
                deferred.resolve(true)
            } else {
                deferred.reject(error)
            }
        }

        return deferred
    }

    func authenticateWithLayerForTheFirstTime(userID: String) -> Deferred {
        let deferred = Deferred()

        self.client!.requestAuthenticationNonceWithCompletion({ (nonce, error) -> Void in
            if let nonce = nonce {
                deferred.resolve(nonce)
            } else {
                deferred.reject(error)
            }
        })

        deferred.then { (result) -> (AnyObject?) in
            self.generateToken((result as? String)!, userID: userID)
        }

        deferred.then { (result) -> (AnyObject?) in
            self.authenticateWithIdentityToken((result as? String)!)
        }

        deferred.catch { (error) -> () in
            println(error)
        }

        return deferred
    }

    func generateToken(nonce: String, userID: String) -> Promise {
        return Promise { (resolve, reject) -> () in
            PFCloud.callFunctionInBackground("generateToken", withParameters: ["nonce": nonce, "userID": userID], block: { (object, error) -> Void in
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
