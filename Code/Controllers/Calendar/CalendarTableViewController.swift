//
//  CalendarViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/26/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CalendarTableViewController: PFQueryTableViewController {
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)

        self.parseClassName = "Billing"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 25
    }

    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Billing")
        query.orderByAscending("created_at")
        return query
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! CalendarEventTableViewCell

        cell.dateLabel.text = "Test"

        return cell
    }
}
