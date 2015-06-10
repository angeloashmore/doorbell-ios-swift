//
//  DirectoryFilterViewController.swift
//  Doorbell
//
//  Created by Angelo on 6/9/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit

class DirectoryFilterViewController: FormViewController {
    // MARK: Class Properties


    // MARK: Instance Properties
    @IBAction func applyButton(sender: UIBarButtonItem) {
        submit()
    }


    // MARK: Life-Cycle Methods
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)

        formView = DirectoryFilterFormView()
    }


    // MARK: Methods
}
