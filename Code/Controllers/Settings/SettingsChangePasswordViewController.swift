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

class SettingsChangePasswordViewController: FormViewController {

    // MARK: Class Properties


    // MARK: Instance Properties


    // MARK: Life-Cycle Methods
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)

        self.formView = SettingsChangePasswordFormView()
    }


    // MARK: FormViewController Methods
    override func configureUI() {
        title = "Change Password"

        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "submit")
        navigationItem.rightBarButtonItem = saveButton

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        navigationItem.leftBarButtonItem = cancelButton
    }

    override func configureValidator() {
        let formView = self.formView as! SettingsChangePasswordFormView

        validator.registerField(formView.cells.password.textField, rules: [RequiredRule(),PasswordRule(regex: "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,}$")])
        validator.registerField(formView.cells.passwordVerify.textField, rules: [ConfirmationRule(confirmField: formView.cells.password.textField)])
    }

    override func validationSuccessful() {
        let formView = self.formView as! SettingsChangePasswordFormView

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


    // MARK: Methods
    func cancel() {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
