//
//  ParsePromiseKit.swift
//  Doorbell
//
//  Created by Angelo on 5/30/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import PromiseKit

extension PFAnonymousUtils {
    static func promiseLogIn() -> Promise<PFUser> {
        return Promise { fulfill, reject in
            self.logInWithBlock(PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}

extension PFCloud {
    static func promiseFunction(function: String, withParameters parameters: Dictionary<NSObject, AnyObject>) -> Promise<AnyObject> {
        return Promise { fulfill, reject in
            self.callFunctionInBackground(function, withParameters: parameters, block: PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}

extension PFFile {
    func promiseGetData() -> Promise<NSData> {
        return Promise { fulfill, reject in
            self.getDataInBackgroundWithBlock(PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    func promiseGetDataStream() -> Promise<NSInputStream> {
        return Promise { fulfill, reject in
            self.getDataStreamInBackgroundWithBlock(PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    func promiseSave() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.saveInBackgroundWithBlock(PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}

extension PFGeoPoint {
    static func promiseGeoPointForCurrentLocation() -> Promise<PFGeoPoint> {
        return Promise { fulfill, reject in
            self.geoPointForCurrentLocationInBackground(PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}

extension PFObject {
    func promiseFetch() -> Promise<PFObject> {
        return Promise { fulfill, reject in
            self.fetchInBackgroundWithBlock(PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    func promiseFetchIfNeeded() -> Promise<PFObject> {
        return Promise { fulfill, reject in
            self.fetchIfNeededInBackgroundWithBlock(PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseFetchAll(objects: Array<PFObject>) -> Promise<Array<AnyObject>> {
        return Promise { fulfill, reject in
            self.fetchAllInBackground(objects, block: PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseFetchAllIfNeeded(objects: Array<PFObject>) -> Promise<Array<AnyObject>> {
        return Promise { fulfill, reject in
            self.fetchAllIfNeededInBackground(objects, block: PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    func promiseSave() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.saveInBackgroundWithBlock(PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseSaveAll(objects: Array<PFObject>) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.saveAllInBackground(objects, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    func promiseDelete() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.deleteInBackgroundWithBlock(PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseDeleteAll(objects: Array<PFObject>) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.deleteAllInBackground(objects, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}

extension PFQuery {
    static func promiseGetObjectOfClass(objectClass: String, objectId: String) -> Promise<PFObject> {
        return Promise { fulfill, reject in
            var error: NSError?

            let object = self.getObjectOfClass(objectClass, objectId: objectId, error: &error)

            if let object = object {
                fulfill(object)
            } else {
                reject(error!)
            }
        }
    }

    func promiseGetObjectWithId(objectId: String) -> Promise<PFObject> {
        return Promise { fulfill, reject in
            self.getObjectInBackgroundWithId(objectId, block: PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseGetUserObjectWithId(objectId: String) -> Promise<PFObject> {
        return Promise { fulfill, reject in
            var error: NSError?

            let object = self.getUserObjectWithId(objectId, error: &error)

            if let object = object {
                fulfill(object)
            } else {
                reject(error!)
            }
        }
    }

    func promiseFindObjects() -> Promise<[AnyObject]> {
        return Promise { fulfill, reject in
            self.findObjectsInBackgroundWithBlock(PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    func promiseGetFirstObject() -> Promise<PFObject> {
        return Promise { fulfill, reject in
            self.getFirstObjectInBackgroundWithBlock(PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    func promiseCountObjects() -> Promise<Int32> {
        return Promise { fulfill, reject in
            self.countObjectsInBackgroundWithBlock(PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}

extension PFUser {
    func promiseSignUp() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.signUpInBackgroundWithBlock(PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseBecome(sessionToken: String) -> Promise<PFUser> {
        return Promise { fulfill, reject in
            self.becomeInBackground(sessionToken, block: PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseLogInWithUsername(username: String, password: String) -> Promise<PFUser> {
        return Promise { fulfill, reject in
            self.logInWithUsernameInBackground(username, password: password, block: PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseRequestPasswordResetForEmail(email: String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.requestPasswordResetForEmailInBackground(email, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseLogOut() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.logOutInBackgroundWithBlock(PromisePFClosures.ErrorPassthroughBlock(fulfill: fulfill, reject: reject, passthrough: true))
        }
    }
}

extension PFImageView {
    func promiseLoad() -> Promise<UIImage> {
        return Promise { fulfill, reject in
            self.loadInBackground(PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}

extension PFPurchase {
    static func promiseBuyProduct(productIdentifier: String) -> Promise<String> {
        return Promise { fulfill, reject in
            self.buyProduct(productIdentifier, block: PromisePFClosures.ErrorPassthroughBlock(fulfill: fulfill, reject: reject, passthrough: productIdentifier))
        }
    }

    static func promiseDownloadAssetForTransaction(transaction: SKPaymentTransaction) -> Promise<String> {
        return Promise { fulfill, reject in
            self.downloadAssetForTransaction(transaction, completion: PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}

extension PFPush {
    static func promiseSendPushMessageToChannel(channel: String, withMessage message: String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.sendPushMessageToChannelInBackground(channel, withMessage: message, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseSendPushMessageToQuery(query: PFQuery, withMessage message: String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.sendPushMessageToQueryInBackground(query, withMessage: message, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    func promiseSendPush() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.sendPushInBackgroundWithBlock(PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseSendPushDataToChannel(channel: String, withData data: [NSObject: AnyObject]) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.sendPushDataToChannelInBackground(channel, withData: data, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseSendPushDataToQuery(query: PFQuery, withData data: [NSObject: AnyObject]) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.sendPushDataToQueryInBackground(query, withData: data, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseGetSubscribedChannels() -> Promise<Set<NSObject>> {
        return Promise { fulfill, reject in
            self.getSubscribedChannelsInBackgroundWithBlock(PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseSubscribeToChannel(channel: String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.subscribeToChannelInBackground(channel, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseUnsubscribeFromChannel(channel: String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.unsubscribeFromChannelInBackground(channel, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}

extension PFTwitterUtils {
    static func promiseLogIn() -> Promise<PFUser> {
        return Promise { fulfill, reject in
            self.logInWithBlock(PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseLogInWithTwitterId(twitterId: String, screenName: String, authToken: String, authTokenSecret: String) -> Promise<PFUser> {
        return Promise { fulfill, reject in
            self.logInWithTwitterId(twitterId, screenName: screenName, authToken: authToken, authTokenSecret: authTokenSecret, block: PromisePFClosures.OptionalResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseLinkUser(user: PFUser) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.linkUser(user, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseLinkUser(user: PFUser, twitterId: String, screenName: String, authToken: String, authTokenSecret: String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.linkUser(user, twitterId: twitterId, screenName: screenName, authToken: authToken, authTokenSecret: authTokenSecret, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }

    static func promiseUnlinkUser(user: PFUser) -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.unlinkUserInBackground(user, block: PromisePFClosures.ResultBlock(fulfill: fulfill, reject: reject))
        }
    }
}
