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
import Evergreen
import KHAForm

class SettingsViewController: KHAFormViewController, KHAFormViewDataSource {

    // MARK: Class Properties


    // MARK: Instance Properties
    let formView = SettingsFormView()


    // MARK: Life-Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureCells()
    }

    
    // MARK: KHAFormViewDataSource Protocol Methods
    override func formCellsInForm(form: KHAFormViewController) -> [[KHAFormCell]] {
        return formView.cellsInSections
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return formView.footerForSection(section)
    }


    // MARK: Methods
    func configureUI() {
        title = "Settings"
    }

    func configureCells() {
        formView.cells.privateAccount.sswitch.setOn(PFUser.currentUser()!.objectForKey("private") as! Bool, animated: true)

        formView.cells.editProfile.button.addTarget(self, action: "handleEditProfileButton", forControlEvents: UIControlEvents.TouchUpInside)
        formView.cells.changePassword.button.addTarget(self, action: "handleChangePasswordButton", forControlEvents: UIControlEvents.TouchUpInside)
        formView.cells.privateAccount.sswitch.addTarget(self, action: "handlePrivateAccountSwitch", forControlEvents: UIControlEvents.ValueChanged)
        formView.cells.aboutThisVersion.button.addTarget(self, action: "handleAboutThisVersionButton", forControlEvents: UIControlEvents.TouchUpInside)
        formView.cells.logOut.button.addTarget(self, action: "handleLogOutButton", forControlEvents: UIControlEvents.TouchUpInside)
    }

    func handleEditProfileButton() {
        performSegueWithIdentifier("EditProfile", sender: nil)
    }

    func handleChangePasswordButton() {
        performSegueWithIdentifier("ChangePassword", sender: nil)
    }

    func handlePrivateAccountSwitch() {
        let value = formView.cells.privateAccount.sswitch.on

        let user = PFUser.currentUser()!
        user.setValue(value, forKey: "private")

        user.promiseSave()
    }

    func handleAboutThisVersionButton() {
        performSegueWithIdentifier("AboutThisVersion", sender: nil)
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