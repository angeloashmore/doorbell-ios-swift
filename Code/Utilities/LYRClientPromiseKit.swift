//
//  LYRClientPromiseKit.swift
//
//  Created by Angelo Ashmore on 6/2/15.
//  Copyright (c) 2015 Angelo Ashmore. All rights reserved.
//

import LayerKit
import PromiseKit

extension LYRClient {
    public func promiseAuthenticateWithIdentityToken(identityToken: String) -> Promise<String> {
        return Promise { fulfill, reject in
            self.authenticateWithIdentityToken(identityToken, completion: LYRCLientPromiseKitClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    public func promiseRequestAuthenticationNonce() -> Promise<String> {
        return Promise { fulfill, reject in
            self.requestAuthenticationNonceWithCompletion(LYRCLientPromiseKitClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    public func promiseDeauthenticate() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.deauthenticateWithCompletion(LYRCLientPromiseKitClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    public func promiseConnect() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.connectWithCompletion(LYRCLientPromiseKitClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}
