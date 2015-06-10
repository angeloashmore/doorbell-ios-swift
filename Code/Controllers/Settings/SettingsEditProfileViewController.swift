//
//  EditProfileViewController.swift
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
import SwiftValidator

class SettingsEditProfileViewController: FormViewController {

    // MARK: Class Properties


    // MARK: Instance Properties


    // MARK: Life-Cycle Methods
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)

        formView = SettingsEditProfileFormView()
    }


    // MARK: FormViewController Methods
    override func configureUI() {
        title = "Edit Profile"

        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "submit")
        navigationItem.rightBarButtonItem = saveButton

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        navigationItem.leftBarButtonItem = cancelButton
    }

    override func configureCells() {
        let formView = self.formView as! SettingsEditProfileFormView

        let user = PFUser.currentUser()!

        formView.cells.firstName.textField.text = user.objectForKey("firstName") as? String
        formView.cells.lastName.textField.text = user.objectForKey("lastName") as? String
        formView.cells.email.textField.text = user.objectForKey("email") as? String

        formView.cells.professionOrganization.textField.text = user.objectForKey("professionOrganization") as? String
        formView.cells.professionTitle.selectionFormViewController.selectedIndex = user.objectForKey("professionTitle") as! Int
        formView.cells.professionTitle.detailTextLabel?.text = formView.cells.professionTitle.selectionFormViewController.selections[user.objectForKey("professionTitle") as! Int]
        formView.cells.professionLocation.selectionFormViewController.selectedIndex = user.objectForKey("professionLocation") as! Int
        formView.cells.professionLocation.detailTextLabel?.text = formView.cells.professionLocation.selectionFormViewController.selections[user.objectForKey("professionLocation") as! Int]
    }

    override func configureValidator() {
        let formView = self.formView as! SettingsEditProfileFormView

        validator.registerField(formView.cells.firstName.textField, rules: [RequiredRule()])
        validator.registerField(formView.cells.lastName.textField, rules: [RequiredRule()])
        validator.registerField(formView.cells.email.textField, rules: [RequiredRule(), EmailRule()])

        validator.registerField(formView.cells.professionOrganization.textField, rules: [RequiredRule()])
    }

    override func validationSuccessful() {
        let formView = self.formView as! SettingsEditProfileFormView

        let user = PFUser.currentUser()!

        user["firstName"] = formView.cells.firstName.textField.text
        user["lastName"] = formView.cells.lastName.textField.text
        user["email"] = formView.cells.email.textField.text
        user["professionOrganization"] = formView.cells.professionOrganization.textField.text
        user["professionTitle"] = formView.cells.professionTitle.selectionFormViewController.selectedIndex
        user["professionLocation"] = formView.cells.professionLocation.selectionFormViewController.selectedIndex

        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        user.promiseSave()
            .then { _ -> Void in
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
                self.cancel()
                
            }.catch(policy: .AllErrors) { (error) -> Void in
                PKHUD.sharedHUD.hide()

                var message: String

                switch error.code {
                case 203:
                    message = "Email taken. Please try another email."
                default:
                    message = "An error occured. Please re-check all fields and try again."
                }

                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)

                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(OKAction)

                self.presentViewController(alertController, animated: true, completion: nil)
            }
    }


    // MARK: Methods
    func cancel() {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
}