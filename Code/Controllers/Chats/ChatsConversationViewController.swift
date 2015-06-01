//
//  ChatsConversaionViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/27/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import LayerKit
import Parse
import Evergreen

class ChatsConversationViewController: ATLConversationViewController, ATLConversationViewControllerDataSource, ATLConversationViewControllerDelegate, ATLParticipantTableViewControllerDelegate {

    var dateFormatter: NSDateFormatter?
    var usersArray:  NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Chat"

        self.dataSource = self
        self.delegate = self
        self.addressBarController?.delegate = self

        self.dateFormatter = NSDateFormatter()
        self.dateFormatter!.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter!.timeStyle = NSDateFormatterStyle.ShortStyle

        self.configureUI()
    }

    func configureUI() {
        ATLOutgoingMessageCollectionViewCell.appearance().messageTextColor = UIColor.whiteColor()
        ATLOutgoingMessageCollectionViewCell.appearance().bubbleViewColor = self.view.tintColor
    }

    func conversationViewController(viewController: ATLConversationViewController!, didSendMessage message: LYRMessage!) {
        log("Message sent", forLevel: .Debug)
    }

    func conversationViewController(viewController: ATLConversationViewController!, didFailSendingMessage message: LYRMessage!, error: NSError!) {
        log("Message failed to send with error: \(error)", forLevel: .Error)
    }

    func conversationViewController(viewController: ATLConversationViewController!, didSelectMessage message: LYRMessage!) {
        log("Message selected", forLevel: .Debug)
    }

    func conversationViewController(conversationViewController: ATLConversationViewController!, participantForIdentifier participantIdentifier: String!) -> ATLParticipant! {
        if participantIdentifier == PFUser.currentUser()?.objectId { return PFUser.currentUser() }

        let user = UserManager.sharedManager.cachedUserForUserID(participantIdentifier)

        if user == nil {
            UserManager.sharedManager.queryAndCacheUsersWithIDs([participantIdentifier])

            .then { (participants) -> () in
//                self.addressBarController.reloadView()
//                self.reloadCellsForMessagesSentByParticipantWithIdentifier(participantIdentifier)

            }.catch { (error) -> () in
                log("Error querying for users: \(error)", forLevel: .Error)

            }
        }

        return user
    }

    func conversationViewController(conversationViewController: ATLConversationViewController!, attributedStringForDisplayOfDate date: NSDate!) -> NSAttributedString! {
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(14.0), NSForegroundColorAttributeName: UIColor.grayColor()]
        return NSAttributedString(string: self.dateFormatter!.stringFromDate(date), attributes: attributes)
    }

    func conversationViewController(conversationViewController: ATLConversationViewController!, attributedStringForDisplayOfRecipientStatus recipientStatus: [NSObject : AnyObject]!) -> NSAttributedString! {
        if recipientStatus.count == 0 { return nil }

        let mergedStatuses = NSMutableAttributedString()


//        if (recipientStatus.count == 0) return nil;
//        NSMutableAttributedString *mergedStatuses = [[NSMutableAttributedString alloc] init];
//
//        [[recipientStatus allKeys] enumerateObjectsUsingBlock:^(NSString *participant, NSUInteger idx, BOOL *stop) {
//            LYRRecipientStatus status = [recipientStatus[participant] unsignedIntegerValue];
//            if ([participant isEqualToString:self.layerClient.authenticatedUserID]) {
//                return;
//            }
//
//            NSString *checkmark = @"✔︎";
//            UIColor *textColor = [UIColor lightGrayColor];
//            if (status == LYRRecipientStatusSent) {
//                textColor = [UIColor lightGrayColor];
//            } else if (status == LYRRecipientStatusDelivered) {
//                textColor = [UIColor orangeColor];
//            } else if (status == LYRRecipientStatusRead) {
//                textColor = [UIColor greenColor];
//            }
//            NSAttributedString *statusString = [[NSAttributedString alloc] initWithString:checkmark attributes:@{NSForegroundColorAttributeName: textColor}];
//            [mergedStatuses appendAttributedString:statusString];
//        }];
    return mergedStatuses;
    }

    override func addressBarViewController(addressBarViewController: ATLAddressBarViewController!, didTapAddContactsButton addContactsButton: UIButton!) {
        UserManager.sharedManager.queryForAllUsers()

        .then { (users) -> () in
            let controller = ChatsParticipantTableViewController(participants: NSSet(array: users) as Set<NSObject>, sortType: ATLParticipantPickerSortType.FirstName)
            controller.delegate = self

            let navigationController = UINavigationController(rootViewController: controller)
            self.navigationController?.presentViewController(navigationController, animated: true, completion: nil)

        }.catch { (error) -> () in
            log("Error querying for All Users: \(error)", forLevel: .Error)
            
        }
    }

    override func addressBarViewController(addressBarViewController: ATLAddressBarViewController!, searchForParticipantsMatchingText searchText: String!, completion: (([AnyObject]!) -> Void)!) {
        UserManager.sharedManager.queryForUserWithName(searchText)

        .then { (users) -> () in
            completion(users)

        }.catch { (error) -> () in
            log("Error search for participants: \(error)", forLevel: .Error)
        }
    }

    func participantTableViewController(participantTableViewController: ATLParticipantTableViewController!, didSelectParticipant participant: ATLParticipant!) {
        log("Participant: \(participant)", forLevel: .Debug)
        self.addressBarController.selectParticipant(participant)
        log("Selected Participants: \(self.addressBarController.selectedParticipants)", forLevel: .Debug)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func participantTableViewController(participantTableViewController: ATLParticipantTableViewController!, didSearchWithString searchText: String!, completion: ((Set<NSObject>!) -> Void)!) {
        UserManager.sharedManager.queryForUserWithName(searchText)

        .then { (participants) -> () in
            completion(NSSet(array: participants) as Set<NSObject>)

        }.catch { (error) -> () in
            log("Error search for participants: \(error)", forLevel: .Error)

        }
    }

}
