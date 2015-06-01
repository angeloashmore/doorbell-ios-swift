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
        return self["firstName"] as? String
    }

    public var lastName: String? {
        return self["lastName"] as? String
    }

    public var fullName: String? {
        return "\(firstName!) \(lastName!)"
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
        let firstNameInitial = self.firstName![self.firstName!.startIndex]
        let lastNameInitial = self.lastName![self.lastName!.startIndex]
        return "\(firstNameInitial)\(lastNameInitial)"
    }

}
