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
import PromiseKit

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

    public func initializeClient() -> Promise<AnyObject> {
        if self.readyToInitialize() {
            if let userID = PFUser.currentUser()?.objectId {
                return self.loginLayer(userID)
            }
        }

        log("Unsuccessfully initialized Layer Client", forLevel: .Error)
        return Promise(error: "Unsuccessfully initialized Layer Client")
    }

    private func loginLayer(userID: String) -> Promise<AnyObject> {
        return self.connectToLayerServer()
            .then { _ in
                return self.authenticateLayerWithUserID(userID)
            }
    }

    private func connectToLayerServer() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.client!.connectWithCompletion({ (success, error) -> Void in
                if !success {
                    log("Unsuccessfully connected to Layer", forLevel: .Error)
                    reject(error)
                } else {
                    log("Successfully connected to Layer", forLevel: .Info)
                    fulfill(true)
                }
            })
        }
    }

    private func authenticateLayerWithUserID(userID: String) -> Promise<AnyObject> {
        if let authenticatedUserID = self.client!.authenticatedUserID {
            // If the client is already authenticated
            if authenticatedUserID == userID {
                // If the client is authenticated with the correct user
                return Promise { fulfill, reject in
                    log("Successfully authenticated with Layer using existing user ID", forLevel: .Info)
                    fulfill(true)
                }
            } else {
                // If the client is NOT authenticated with the correct user
                return self.deauthenticateWithLayer()
                    .then { _ in
                        return self.authenticateWithLayerForTheFirstTime(userID)
                    }
            }
        } else {
            // If the client is NOT authenticated
            return self.authenticateWithLayerForTheFirstTime(userID)
        }
    }

    public func deauthenticateWithLayer() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.client!.deauthenticateWithCompletion({ (success, error) -> Void in
                if error == nil {
                    log("Successfully deauthenticated from Layer", forLevel: .Info)
                    fulfill(true)
                } else {
                    log("Unsuccessfully deauthenticated from Layer", forLevel: .Error)
                    reject(error)
                }
            })
        }
    }

    private func authenticateWithLayerForTheFirstTime(userID: String) -> Promise<AnyObject> {
        return requestAuthenticationNonce()
            .then { nonce in
                return self.generateToken(nonce, userID: userID)
            }.then { identityToken in
                return self.authenticateWithIdentityToken(identityToken)
            }
    }

    private func requestAuthenticationNonce() -> Promise<String> {
        return Promise { fulfill, reject in
            self.client!.requestAuthenticationNonceWithCompletion({ (nonce, error) -> Void in
                if let nonce = nonce {
                    log("Successfully requested nonce from Layer", forLevel: .Info)
                    fulfill(nonce)
                } else {
                    log("Unsuccessfully requested nonce from Layer", forLevel: .Error)
                    reject(error)
                }
            })
        }
    }

    private func generateToken(nonce: String, userID: String) -> Promise<String> {
        let params = ["nonce": nonce, "userID": userID]

        return PFCloud.promiseFunction("generateToken", withParameters: params)
            .then { object in
                return object as! String
            }
    }

    private func authenticateWithIdentityToken(identityToken: String) -> Promise<String> {
        return Promise { fulfill, reject in
            self.client!.authenticateWithIdentityToken(identityToken, completion: { (authenticatedUserID, error) -> Void in
                if let authenticatedUserID = authenticatedUserID {
                    log("Successfully authenticated with provided identity token", forLevel: .Info)
                    fulfill(authenticatedUserID)
                } else {
                    log("Unsuccessfully authenticated with provided identity token", forLevel: .Error)
                    reject(error)
                }
            })
        }
    }

}
