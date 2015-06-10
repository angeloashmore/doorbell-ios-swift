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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 0

        if Int(arc4random_uniform(7)) != 3 {
            favoriteLabel.hidden = true
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
