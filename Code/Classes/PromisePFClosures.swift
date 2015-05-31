//
//  PromisePFClosures.swift
//  Doorbell
//
//  Created by Angelo on 5/30/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

struct PromisePFClosures {
    static func ResultBlock<T>(#fulfill: T -> Void, reject: NSError -> Void) -> (T, NSError?) -> () {
        return { (result: T, error: NSError?) in
            if let error = error {
                reject(error)
            } else {
                fulfill(result)
            }
        }
    }

    static func OptionalResultBlock<T>(#fulfill: T -> Void, reject: NSError -> Void) -> (T?, NSError?) -> () {
        return { (result: T?, error: NSError?) in
            if let error = error {
                reject(error)
            } else {
                fulfill(result!)
            }
        }
    }

    static func ErrorPassthroughBlock<T>(#fulfill: T -> Void, reject: NSError -> Void, passthrough: T) -> (NSError?) -> () {
        return { (error: NSError?) in
            if let error = error {
                reject(error)
            } else {
                fulfill(passthrough)
            }
        }
    }
}
