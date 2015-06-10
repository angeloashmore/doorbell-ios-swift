//
//  DirectoryViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/26/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DirectoryViewController: PFQueryTableViewController {
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)

        self.parseClassName = "_User"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 25
    }

    override func queryForTable() -> PFQuery {
        let query = PFUser.query()!
        query.orderByAscending("created_at")
        return query
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier("DirectoryCell", forIndexPath: indexPath) as! DirectoryUserTableViewCell

        cell.fullNameLabel?.text = object?.objectForKey("fullName") as? String
        cell.titleLabel?.text = "Real Estate Agent"
        cell.organizationLabel?.text = object?.objectForKey("professionOrganization") as? String

        return cell
    }

    @IBAction func prepareForUnwindFromDirectoryFilterViewController(segue: UIStoryboardSegue) {
    }
}
