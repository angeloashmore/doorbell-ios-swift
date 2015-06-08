//
//  File.swift
//  Doorbell
//
//  Created by Angelo on 6/7/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import Parse

class Event: PFObject, PFSubclassing {
    // MARK: PFSubclassing Setup
    override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }

        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }

    static func parseClassName() -> String {
        return "Event"
    }
}
