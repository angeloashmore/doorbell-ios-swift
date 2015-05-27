//
//  PFUser+ATLParticipant.swift
//  Doorbell
//
//  Created by Angelo on 5/27/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import Parse

extension PFUser: ATLParticipant {
    public var firstName: String? {
        return self["name"] as? String
    }

    public var lastName: String? {
        return self["name"] as? String
    }

    public var fullName: String? {
        return self["name"] as? String
    }

    public var participantIdentifier: String? {
        return self.objectId
    }

    public var avatarImageURL: NSURL? {
        return nil
    }

    public var avatarImage: UIImage? {
        return nil
    }

    public var avatarInitials: String {
        return "\(Array(arrayLiteral: self.firstName!)[0])\(Array(arrayLiteral: self.lastName!)[0])"
    }

}
