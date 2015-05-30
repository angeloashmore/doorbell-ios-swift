//
//  UserManager.swift
//  Doorbell
//
//  Created by Angelo on 5/29/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import Parse

class UserManager: NSObject {
    var userCache: NSCache = NSCache()
    static let sharedManager = UserManager()

    func queryForUserWithName(searchText: String) -> Promise {
        return Promise { (resolve, reject) -> () in
            let query = PFUser.query()
            query?.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)

            query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let error = error {
                    reject(error)
                } else {
                    let contacts = NSMutableArray()

                    if let users = objects as? [PFUser] {
                        for user in users {
                            if user.fullName!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
                                contacts.addObject(user)
                            }
                        }
                    }

                    resolve(contacts as [AnyObject])
                }
            })
        }
    }

    func queryForAllUsers() -> Promise {
        return Promise { (resolve, reject) -> () in
            let query = PFUser.query()
            query?.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)

            query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let error = error {
                    reject(error)
                } else {
                    resolve(objects)
                }
            })
        }
    }

    func queryAndCacheUsersWithIDs(userIDs: [String]) -> Promise {
        return Promise { (resolve, reject) -> () in
            let query = PFUser.query()
            query?.whereKey("objectId", containedIn: userIDs)

            query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let error = error {
                    reject(error)
                } else {
                    if let users = objects as? [PFUser] {
                        for user in users {
                            self.cacheUserIfNeeded(user)
                        }

                        if users.count > 0 {
                            resolve(objects)
                        } else {
                            resolve(nil)
                        }
                    }
                }
            })
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

    func unCachedUserIDsFromParticipants(participants: [String]) -> NSArray {
        let array = NSMutableArray()

        for userID in participants {
            if userID == PFUser.currentUser()!.objectId! { continue }
            if self.userCache.objectForKey(userID) == nil {
                array.addObject(userID)
            }
        }

        return NSArray(array: array)
    }

    func resolvedNamesFromParticipants(participants: [String]) -> NSArray {
        let array = NSMutableArray()

        for userID in participants {
            if userID == PFUser.currentUser()!.objectId! { continue }
            if let user = self.userCache.objectForKey(userID) as? PFUser {
                array.addObject(user.firstName!)
            }
        }

        return NSArray(array: array)
    }
}
