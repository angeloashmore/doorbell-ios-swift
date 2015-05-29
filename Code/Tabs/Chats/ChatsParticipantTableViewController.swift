//
//  ChatsParticipantTableViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/29/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation

class ChatsParticipantTableViewController: ATLParticipantTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let cancelItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "handleCancelTap")
        self.navigationItem.leftBarButtonItem = cancelItem
    }

    func handleCancelTap() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
