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

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return PFUser.currentUser()
    }

    func conversationViewController(conversationViewController: ATLConversationViewController!, attributedStringForDisplayOfDate date: NSDate!) -> NSAttributedString! {
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(14.0), NSForegroundColorAttributeName: UIColor.grayColor()]
        return NSAttributedString(string: self.dateFormatter!.stringFromDate(date), attributes: attributes)
    }

    func conversationViewController(conversationViewController: ATLConversationViewController!, attributedStringForDisplayOfRecipientStatus recipientStatus: [NSObject : AnyObject]!) -> NSAttributedString! {
//        if recipientStatus.count == 0 {
//            return nil
//        }
//
//        var mergedStatuses = NSMutableAttributedString()
//
//        for key in recipientStatus.keys {
//
//        }
        return nil
    }

    override func addressBarViewController(addressBarViewController: ATLAddressBarViewController!, didTapAddContactsButton addContactsButton: UIButton!) {
        // no-op
    }

    override func addressBarViewController(addressBarViewController: ATLAddressBarViewController!, searchForParticipantsMatchingText searchText: String!, completion: (([AnyObject]!) -> Void)!) {
        // no-op
    }

    func participantTableViewController(participantTableViewController: ATLParticipantTableViewController!, didSelectParticipant participant: ATLParticipant!) {
        // no-op
    }

    func participantTableViewController(participantTableViewController: ATLParticipantTableViewController!, didSearchWithString searchText: String!, completion: ((Set<NSObject>!) -> Void)!) {
        // no-op
    }

}
