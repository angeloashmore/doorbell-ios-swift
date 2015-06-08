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

class SettingsEditProfileViewController: KHAFormViewController, KHAFormViewDataSource, ValidationDelegate {

    // MARK: Class Properties


    // MARK: Instance Properties
    let formView = SettingsEditProfileFormView()
    let validator = Validator()


    // MARK: Life-Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureCells()
        configureValidator()
    }


    // MARK: KHAFormViewDataSource Protocol Methods
    override func formCellsInForm(form: KHAFormViewController) -> [[KHAFormCell]] {
        return formView.cellsInSections
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return formView.footerForSection(section)
    }


    // MARK: ValidatorDelegate Protocol Methods
    func validationSuccessful() {
        let user = PFUser.currentUser()!

        user["firstName"] = formView.cells.firstName.textField.text
        user["lastName"] = formView.cells.lastName.textField.text
        user["email"] = formView.cells.email.textField.text

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

    func validationFailed(errors: [UITextField : ValidationError]) {
        log(errors, forLevel: .Error)

        let alertController = UIAlertController(title: "Error", message: "Please re-check all fields and try again", preferredStyle: .Alert)

        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }


    // MARK: Methods
    func configureUI() {
        title = "Edit Profile"

        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "submit")
        navigationItem.rightBarButtonItem = saveButton

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        navigationItem.leftBarButtonItem = cancelButton
    }

    func configureCells() {
        formView.cells.firstName.textField.text = PFUser.currentUser()?.objectForKey("firstName") as? String
        formView.cells.lastName.textField.text = PFUser.currentUser()?.objectForKey("lastName") as? String
        formView.cells.email.textField.text = PFUser.currentUser()?.objectForKey("email") as? String
    }

    func configureValidator() {
        validator.registerField(formView.cells.firstName.textField, rules: [RequiredRule()])
        validator.registerField(formView.cells.lastName.textField, rules: [RequiredRule()])
        validator.registerField(formView.cells.email.textField, rules: [RequiredRule(), EmailRule()])
    }

    func submit() {
        validator.validate(self)
    }

    func cancel() {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
}