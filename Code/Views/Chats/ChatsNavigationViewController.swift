//
//  ChatsNavigationViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/26/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit

class ChatsNavigationViewController: UINavigationController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)

        let rootViewController = ChatsConversationListViewController(layerClient: LayerClient.sharedClient.client)
        self.setViewControllers([rootViewController], animated: false)
    }

}
