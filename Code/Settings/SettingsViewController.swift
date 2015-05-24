//
//  SettingsViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/23/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import PKHUD
import SwiftForms
import Honour

class SettingsViewController: FormViewController, FormViewControllerDelegate {

    // MARK: Class Properties
    private struct Tags {
        static let logOut = "logOut"
    }

    private struct Validators {
    }


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    /// MARK: FormViewControllerDelegate
    func formViewController(controller: FormViewController, didSelectRowDescriptor rowDescriptor: FormRowDescriptor) {
        switch rowDescriptor.tag {
        case Tags.logOut:
            handleLogOutButton()
        default:
            break
        }
    }


    // MARK: Methods
    private func loadForm() {
        let form = FormDescriptor()

        form.title = "Settings"

        let section1 = FormSectionDescriptor()

        var row = FormRowDescriptor(tag: Tags.logOut, rowType: FormRowType.Button, title: "Log Out")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["titleLabel.textAlignment": NSTextAlignment.Left.rawValue, "titleLabel.textColor": UIColor(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1.0)]
        section1.addRow(row)

        form.sections = [section1]

        self.form = form
    }

    func handleLogOutButton() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .ActionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            PFUser.logOutInBackgroundWithBlock { (error) -> Void in
                if error == nil {
                    // Logged out!
                    let authenticationStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
                    let authenticationVC = authenticationStoryboard.instantiateInitialViewController() as! UIViewController
                    self.presentViewController(authenticationVC, animated: true, completion: nil)
                } else {
                    // Error logging out!
                }
            }
        }
        alertController.addAction(OKAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }

}