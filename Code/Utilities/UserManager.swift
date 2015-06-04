//
//  UserManager.swift
//  Doorbell
//
//  Created by Angelo on 5/29/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

class UserManager: NSObject {
    // MARK: Class Properties
    static let sharedManager = UserManager()


    // MARK: Instance Properties
    var userCache = NSCache()
    

    // MARK: Methods
    func queryForUserWithName(searchText: String) -> Promise<[AnyObject]> {
        let query = PFUser.query()!
        query.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)

        return query.promiseFindObjects()
            .then { objects -> [AnyObject] in
                let contacts = NSMutableArray()

                for object in objects {
                    if object.fullName!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
                        contacts.addObject(object)
                    }
                }

                return contacts as [AnyObject]
            }
    }

    func queryForAllUsers() -> Promise<[AnyObject]> {
        let query = PFUser.query()!
        query.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)

        return query.promiseFindObjects()
    }

    func queryAndCacheUsersWithIDs(userIDs: [String]) -> Promise<[AnyObject]> {
        let query = PFUser.query()!
        query.whereKey("objectId", containedIn: userIDs)

        return query.promiseFindObjects()
            .then { objects -> [AnyObject] in
                for object in objects {
                    self.cacheUserIfNeeded(object as! PFUser)
                }

                return objects
            }
    }

    func cachedUserForUserID(userID: String) -> PFUser? {
        if let user = self.userCache.objectForKey(userID) as? PFUser {
            return user
        }

        return nil
    }

    func cacheUserIfNeeded(user: PFUser) {
        if self.userCache.objectForKey(user.objectId!) == nil {
            self.userCache.setObject(user, forKey: user.objectId!)
        }
    }

    func unCachedUserIDsFromParticipants(participants: Set<NSObject>) -> NSArray {
        let array = NSMutableArray()

        for userID in participants {
            if userID == PFUser.currentUser()!.objectId! { continue }
            if self.userCache.objectForKey(userID) == nil {
                array.addObject(userID)
            }
        }

        return NSArray(array: array)
    }

    func resolvedNamesFromParticipants(participants: Set<NSObject>) -> NSArray {
        let array = NSMutableArray()

        for userID in participants {
            if userID == PFUser.currentUser()!.objectId! { continue }
            if let user = self.userCache.objectForKey(userID) as? PFUser {
                array.addObject(user.fullName!)
            }
        }

        return NSArray(array: array)
    }
}
