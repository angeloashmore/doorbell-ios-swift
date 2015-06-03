//
//  LYRClientPromiseKit.swift
//
//  Created by Angelo Ashmore on 6/2/15.
//  Copyright (c) 2015 Angelo Ashmore. All rights reserved.
//

import LayerKit
import PromiseKit
import PromiseKitClosures

extension LYRClient {
    public func promiseAuthenticateWithIdentityToken(identityToken: String) -> Promise<String> {
        return Promise { fulfill, reject in
            self.authenticateWithIdentityToken(identityToken, completion: PromiseKitClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    public func promiseRequestAuthenticationNonce() -> Promise<String> {
        return Promise { fulfill, reject in
            self.requestAuthenticationNonceWithCompletion(PromiseKitClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    public func promiseDeauthenticate() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.deauthenticateWithCompletion(PromiseKitClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    public func promiseConnect() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.connectWithCompletion(PromiseKitClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}
