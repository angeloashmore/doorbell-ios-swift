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

    func queryForUserWithName(searchText: String, completion: (NSArray?, NSError?) -> Void) {
        let query = PFUser.query()
        query?.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)

        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let error = error {
                let contacts = NSMutableArray.new()

                if let users = objects as? [PFUser] {
                    for user in users {
                        if user.fullName!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil {
                            contacts.addObject(user)
                        }
                    }
                    completion(NSArray(array: contacts), nil)
                }
            } else {
                completion(nil, error)
            }
        })
    }

    func queryForAllUsersWithCompletion(completion: ([AnyObject]?, NSError?) -> Void) {
        let query = PFUser.query()
        query?.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)

        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                completion(objects, nil)
            } else {
                completion(nil, error)
            }
        })
    }

    func queryAndCacheUsersWithIDs(userIDs: [String], completion: (NSArray?, NSError?) -> Void) {
        let query = PFUser.query()
        query?.whereKey("objectId", containedIn: userIDs)

        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                if let users = objects as? [PFUser] {
                    for user in users {
                        self.cacheUserIfNeeded(user)
                    }
                }
                objects!.count > 0 ? completion(objects, nil) : completion(nil, nil)
            } else {
                completion(nil, error)
            }
        })
    }

    func cachedUserForUserID(userID: String) -> PFUser? {
        if self.userCache.objectForKey(userID) != nil {
            return self.userCache.objectForKey(userID) as? PFUser
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
            if self.userCache.objectForKey(userID) != nil {
                let user = self.userCache.objectForKey(userID) as! PFUser
                array.addObject(user.firstName!)
            }
        }

        return NSArray(array: array)
    }
}
