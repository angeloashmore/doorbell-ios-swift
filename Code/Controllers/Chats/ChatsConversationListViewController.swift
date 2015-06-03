//
//  ChatsViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/23/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import LayerKit
import PKHUD
import Parse
import Evergreen

class ChatsConversationListViewController: ATLConversationListViewController, ATLConversationListViewControllerDelegate, ATLConversationListViewControllerDataSource {

    // MARK: Life-Cycle Methods
    override func viewDidLoad() {
        self.title = "Chats"

        self.dataSource = self
        self.delegate = self

        self.configureUI()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let composeButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "composeButtonTapped")
        self.navigationItem.rightBarButtonItem = composeButton
    }


    // MARK: Methods
    func configureUI() {
        ATLConversationTableViewCell.appearance().unreadMessageIndicatorBackgroundColor = self.view.tintColor
    }

    func conversationListViewController(conversationListViewController: ATLConversationListViewController!, didSelectConversation conversation: LYRConversation!) {
        let controller = ChatsConversationViewController(layerClient: LayerClient.sharedClient.client)
        controller.conversation = conversation

        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        self.hidesBottomBarWhenPushed = false
    }

    func conversationListViewController(conversationListViewController: ATLConversationListViewController!, didDeleteConversation conversation: LYRConversation!, deletionMode: LYRDeletionMode) {
        log("Deleted conversation")
    }

    func conversationListViewController(conversationListViewController: ATLConversationListViewController!, didFailDeletingConversation conversation: LYRConversation!, deletionMode: LYRDeletionMode, error: NSError!) {
        log("Failed deleting convesation")
    }

    func conversationListViewController(conversationListViewController: ATLConversationListViewController!, didSearchForText searchText: String!, completion: ((Set<NSObject>!) -> Void)!) {
        log("Searched for text")
    }

    func conversationListViewController(conversationListViewController: ATLConversationListViewController!, titleForConversation conversation: LYRConversation!) -> String! {
        if let title = conversation.metadata["title"] as? String {
            return title
        } else {
            let unresolvedParticipants = UserManager.sharedManager.unCachedUserIDsFromParticipants(conversation.participants) as! [String]
            let resolvedNames = UserManager.sharedManager.resolvedNamesFromParticipants(conversation.participants) as! [String]

            if unresolvedParticipants.count > 0 {
                UserManager.sharedManager.queryAndCacheUsersWithIDs(unresolvedParticipants)
                    .then { objects -> Void in
                        if objects.count > 0 {
                            self.reloadCellForConversation(conversation)
                        }
                    }
            }

            if resolvedNames.count > 0 && unresolvedParticipants.count > 0 {
                let names = ", ".join(resolvedNames)
                return "\(names) and \(unresolvedParticipants.count) others"
            } else if resolvedNames.count > 0 && unresolvedParticipants.count == 0 {
                return ", ".join(resolvedNames)
            } else {
                return "Conversation with \(conversation.participants.count) users"
            }
        }
    }

    func composeButtonTapped() {
        let controller = ChatsConversationViewController(layerClient: LayerClient.sharedClient.client)
        controller.displaysAddressBar = true
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
