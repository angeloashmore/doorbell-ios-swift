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

class SettingsViewController: FormViewController {

    // MARK: Class Properties


    // MARK: Instance Properties


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.loadForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
    }


    // MARK: Methods
    func loadForm() {
        let formView = SettingsFormView()

        formView.formRowDescriptors[SettingsFormView.Tags.editProfile]!.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.performSegueWithIdentifier("EditProfile", sender: nil)
        } as DidSelectClosure

        formView.formRowDescriptors[SettingsFormView.Tags.changePassword]!.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.performSegueWithIdentifier("ChangePassword", sender: nil)
        } as DidSelectClosure

        formView.formRowDescriptors[SettingsFormView.Tags.aboutThisVersion]!.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.performSegueWithIdentifier("About", sender: nil)
        } as DidSelectClosure

        formView.formRowDescriptors[SettingsFormView.Tags.logOut]!.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.handleLogOutButton()
        } as DidSelectClosure

        self.form = formView.form
    }

    func handleLogOutButton() {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Log Out", style: .Destructive) { (action) -> Void in
            self.logOut()
        }
        alertController.addAction(OKAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func logOut() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()

        PFUser.promiseLogOut()
            .then { _ in
                return LayerClient.sharedClient.client?.promiseDeauthenticate()

            }.then { _ -> Void in
                PKHUD.sharedHUD.hide()
                self.tabBarController?.dismissViewControllerAnimated(true, completion: nil)

            }
    }

}