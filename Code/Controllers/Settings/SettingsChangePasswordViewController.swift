//
//  SettingsChangePasswordViewController.swift
//  Doorbell
//
//  Created by Angelo on 6/2/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import PKHUD
import Evergreen
import KHAForm
import SwiftValidator
import PromiseKit

class SettingsChangePasswordViewController: KHAFormViewController, FormProtocol {

    // MARK: Class Properties


    // MARK: Instance Properties
    let formView = SettingsChangePasswordFormView()
    let validator = Validator()


    // MARK: Life-Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
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

        user["password"] = formView.cells.password.textField.text

        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        user.promiseSave()
            .then { user -> Promise<Bool> in
                return PFUser.promiseLogOut()

            }.then { _ -> Promise<Bool> in
                return LayerClient.sharedClient.client!.promiseDeauthenticate()

            }.then { _ -> Void in
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
                self.dismissViewControllerAnimated(true, completion: nil)

            }.catch(policy: .AllErrors) { (error) -> Void in
                PKHUD.sharedHUD.hide()

                var message: String

                switch error.code {
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
        title = "Change Password"

        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "submit")
        navigationItem.rightBarButtonItem = saveButton

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        navigationItem.leftBarButtonItem = cancelButton
    }

    func configureCells() {
        // Unused
    }

    func configureValidator() {
        validator.registerField(formView.cells.password.textField, rules: [RequiredRule(),PasswordRule(regex: "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,}$")])
        validator.registerField(formView.cells.passwordVerify.textField, rules: [ConfirmationRule(confirmField: formView.cells.password.textField)])
    }

    func submit() {
        validator.validate(self)
    }

    func cancel() {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
