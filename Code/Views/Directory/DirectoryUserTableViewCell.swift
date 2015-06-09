//
//  DirectoryUserTableViewCell.swift
//  Doorbell
//
//  Created by Angelo on 6/9/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DirectoryUserTableViewCell: PFTableViewCell {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
