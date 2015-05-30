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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.hidden = false

        let composeItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "composeButtonTapped")
        self.navigationItem.rightBarButtonItem = composeItem
    }

    override func viewDidLoad() {
        self.dataSource = self
        self.delegate = self
    }

    func conversationListViewController(conversationListViewController: ATLConversationListViewController!, didSelectConversation conversation: LYRConversation!) {
        log("Selected conversation")
        let controller = ChatsConversationViewController(layerClient: LayerClient.sharedClient.client)
        controller.conversation = conversation
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.pushViewController(controller, animated: true)
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
        return "Title"
    }

    func composeButtonTapped() {
        let controller = ChatsConversationViewController(layerClient: LayerClient.sharedClient.client)
        controller.displaysAddressBar = true
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
