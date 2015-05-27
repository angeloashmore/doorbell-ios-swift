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
import Evergreen

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

    public var client: LYRClient?


    // MARK: Methods
    public func readyToInitialize() -> Bool {
        return client != nil && PFUser.currentUser() != nil
    }

    public func initializeClient() -> Promise {
        if self.readyToInitialize() {
            if let userID = PFUser.currentUser()?.objectId {
                return self.loginLayer(userID)
            }
        }

        return Promise { (resolve, reject) -> () in
            log("Unsuccessfully initialized Layer Client", forLevel: .Error)
            reject(true)
        }
    }

    private func loginLayer(userID: String) -> Promise {
        return self.connectToLayerServer()

        .then { (_) -> (AnyObject?) in
            return self.authenticateLayerWithUserID(userID)
        }
    }

    private func connectToLayerServer() -> Promise {
        return Promise { (resolve, reject) -> () in
            self.client!.connectWithCompletion({ (success, error) -> Void in
                if !success {
                    log("Unsuccessfully connected to Layer", forLevel: .Error)
                    reject(error)
                } else {
                    log("Successfully connected to Layer", forLevel: .Info)
                    resolve(true)
                }
            })
        }
    }

    private func authenticateLayerWithUserID(userID: String) -> Promise {
        if let authenticatedUserID = self.client!.authenticatedUserID {
            // If the client is already authenticated
            if authenticatedUserID == userID {
                // If the client is authenticated with the correct user
                return Promise { (resolve, reject) -> () in
                    log("Successfully authenticated with Layer using existing user ID", forLevel: .Info)
                    resolve(true)
                }
            } else {
                // If the client is NOT authenticated with the correct user
                return self.deauthenticateWithLayer().then { (_) -> () in
                    return self.authenticateWithLayerForTheFirstTime(userID)
                }
            }
        } else {
            // If the client is NOT authenticated
            return self.authenticateWithLayerForTheFirstTime(userID)
        }
    }

    public func deauthenticateWithLayer() -> Promise {
        return Promise { (resolve, reject) -> () in
            self.client!.deauthenticateWithCompletion({ (success, error) -> Void in
                if error == nil {
                    log("Successfully deauthenticated from Layer", forLevel: .Info)
                    resolve(true)
                } else {
                    log("Unsuccessfully deauthenticated from Layer", forLevel: .Error)
                    reject(error)
                }
            })
        }
    }

    private func authenticateWithLayerForTheFirstTime(userID: String) -> Promise {
        return requestAuthenticationNonce()

        .then { (nonce) -> (AnyObject?) in
            return self.generateToken((nonce as? String)!, userID: userID)

        }.then { (identityToken) -> (AnyObject?) in
            return self.authenticateWithIdentityToken((identityToken as? String)!)

        }
    }

    private func requestAuthenticationNonce() -> Promise {
        return Promise { (resolve, reject) -> () in
            self.client!.requestAuthenticationNonceWithCompletion({ (nonce, error) -> Void in
                if let nonce = nonce {
                    log("Successfully requested nonce from Layer", forLevel: .Info)
                    resolve(nonce)
                } else {
                    log("Unsuccessfully requested nonce from Layer", forLevel: .Error)
                    reject(error)
                }
            })
        }
    }

    private func generateToken(nonce: String, userID: String) -> Promise {
        return Promise { (resolve, reject) -> () in
            let params = ["nonce": nonce, "userID": userID]
            PFCloud.callFunctionInBackground("generateToken", withParameters: params, block: { (object, error) -> Void in
                if error == nil {
                    log("Successfully generated token from Parse using nonce from Layer", forLevel: .Info)
                    resolve(object as? String)
                } else {
                    log("Unsuccessfully generated token from Parse using nonce from Layer", forLevel: .Error)
                    reject(error)
                }
            })
        }
    }

    private func authenticateWithIdentityToken(identityToken: String) -> Promise {
        return Promise { (resolve, reject) -> () in
            self.client!.authenticateWithIdentityToken(identityToken, completion: { (authenticatedUserID, error) -> Void in
                if let authenticatedUserID = authenticatedUserID {
                    log("Successfully authenticated with provided identity token", forLevel: .Info)
                    resolve(authenticatedUserID)
                } else {
                    log("Unsuccessfully authenticated with provided identity token", forLevel: .Error)
                    reject(error)
                }
            })
        }
    }

}
