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

    // MARK: Class Properties
    static let sharedClient = LayerClient()


    // MARK: Instance Properties
    public var client: LYRClient?

    public var appID: NSUUID? {
        didSet {
            client = LYRClient(appID: appID)
        }
    }


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
        return Promise(NSError())
    }

    private func loginLayer(userID: String) -> Promise<AnyObject> {
        return self.client!.promiseConnect()
            .then { _ in
                return self.authenticateLayerWithUserID(userID)
            }
    }

    private func authenticateLayerWithUserID(userID: String) -> Promise<AnyObject> {
        if let authenticatedUserID = self.client!.authenticatedUserID {
            // If the client is already authenticated
            if authenticatedUserID == userID {
                // If the client is authenticated with the correct user
                log("Successfully authenticated with Layer using existing user ID", forLevel: .Info)
                return Promise(true)
            } else {
                // If the client is NOT authenticated with the correct user
                return self.client!.promiseDeauthenticate()
                    .then { _ in
                        return self.authenticateWithLayerForTheFirstTime(userID)
                    }
            }
        } else {
            // If the client is NOT authenticated
            return self.authenticateWithLayerForTheFirstTime(userID)
        }
    }

    private func authenticateWithLayerForTheFirstTime(userID: String) -> Promise<AnyObject> {
        return self.client!.promiseRequestAuthenticationNonce()
            .then { nonce in
                return self.generateToken(nonce, userID: userID)
            }.then { identityToken in
                return self.client!.promiseAuthenticateWithIdentityToken(identityToken)
            }
    }

    private func generateToken(nonce: String, userID: String) -> Promise<String> {
        let params = ["nonce": nonce, "userID": userID]

        return PFCloud.promiseFunction("generateToken", withParameters: params)
            .then { object in
                return object as! String
            }
    }

}
