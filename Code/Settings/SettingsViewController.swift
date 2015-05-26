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

class SettingsViewController: FormViewController {

    // MARK: Class Properties
    private struct Tags {
        static let editProfile = "editProfile"
        static let changePassword = "changePassword"
        static let privateAccount = "privateAccount"
        static let aboutThisVersion = "aboutThisVersion"
        static let logOut = "logOut"
    }

    private struct RowConfigurationTypes {
        static let DisclosureIndicatorButton = [
            "titleLabel.textAlignment": NSTextAlignment.Left.rawValue,
            "accessoryType": UITableViewCellAccessoryType.DisclosureIndicator.rawValue
        ]
        static let DefaultButton = [
            "titleLabel.textAlignment": NSTextAlignment.Left.rawValue,
            "titleLabel.textColor": UIColor(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1.0),
        ]
    }


    // MARK: Life-Cycle Methods
    override func viewDidLoad() {
        self.loadForm()
    }


    // MARK: Methods
    private func loadForm() {
        var row: FormRowDescriptor
        let form = FormDescriptor()

        form.title = "Settings"

        let userSection = FormSectionDescriptor()
        userSection.footerTitle = "When your account is private, only people you approve can see your profile and interact with you."
        
        row = FormRowDescriptor(tag: Tags.editProfile, rowType: .Button, title: "Edit Profile")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = RowConfigurationTypes.DisclosureIndicatorButton
        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
//            self.performSegueWithIdentifier("EditProfileSegue", sender: nil)
        } as DidSelectClosure
        userSection.addRow(row)

        row = FormRowDescriptor(tag: Tags.changePassword, rowType: .Button, title: "Change Password")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = RowConfigurationTypes.DisclosureIndicatorButton
        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
//            self.performSegueWithIdentifier("ChangePasswordSegue", sender: nil)
        } as DidSelectClosure
        userSection.addRow(row)

        row = FormRowDescriptor(tag: Tags.privateAccount, rowType: .BooleanSwitch, title: "Private Account")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = RowConfigurationTypes.DisclosureIndicatorButton
        userSection.addRow(row)

        let aboutSection = FormSectionDescriptor()

        row = FormRowDescriptor(tag: Tags.aboutThisVersion, rowType: .Button, title: "About This Version")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = RowConfigurationTypes.DisclosureIndicatorButton
        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
//            self.performSegueWithIdentifier("AboutThisVersionSegue", sender: nil)
        } as DidSelectClosure
        aboutSection.addRow(row)

        let logOutSection = FormSectionDescriptor()

        row = FormRowDescriptor(tag: Tags.logOut, rowType: .Button, title: "Log Out")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = RowConfigurationTypes.DefaultButton
        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.handleLogOutButton()
        } as DidSelectClosure
        logOutSection.addRow(row)

        form.sections = [userSection, aboutSection, logOutSection]

        self.form = form
    }

    func handleLogOutButton() {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Log Out", style: .Destructive) { (action) -> Void in
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            PKHUD.sharedHUD.show()

            PFUser.logOutInBackgroundWithBlock { (error) -> Void in
                if error == nil {
                    // Logged out!
                    LayerClient.sharedClient.deauthenticateWithLayer().then({ (_) -> () in
                        PKHUD.sharedHUD.hide()
                        self.tabBarController?.dismissViewControllerAnimated(true, completion: nil)
                    }).catch({ (error) -> () in
                        println(error)
                    })
                } else {
                    // Error logging out!
                }
            }
        }
        alertController.addAction(OKAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }

}