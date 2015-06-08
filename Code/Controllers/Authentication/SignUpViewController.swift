//
//  SignUpFormViewController.swift
//  Doorbell
//
//  Created by Angelo Ashmore on 5/22/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import PKHUD
import Evergreen
import KHAForm
import SwiftValidator

class SignUpViewController: FormViewController {

    // MARK: Class Properties


    // MARK: Instance Properties


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)

        self.formView = SignUpFormView()
    }


    // MARK: FormViewController Methods
    override func configureUI() {
        title = "Sign Up"

        let submitButton = UIBarButtonItem(title: "Submit", style: .Done, target: self, action: "submit")
        navigationItem.rightBarButtonItem = submitButton
    }

    override func configureValidator() {
        let formView = self.formView as! SignUpFormView

        validator.registerField(formView.cells.firstName.textField, rules: [RequiredRule()])
        validator.registerField(formView.cells.lastName.textField, rules: [RequiredRule()])
        validator.registerField(formView.cells.email.textField, rules: [RequiredRule(), EmailRule()])
        validator.registerField(formView.cells.username.textField, rules: [RequiredRule()])
        validator.registerField(formView.cells.password.textField, rules: [RequiredRule()])
        validator.registerField(formView.cells.passwordVerify.textField, rules: [ConfirmationRule(confirmField: formView.cells.password.textField)])
    }

    override func validationSuccessful() {
        let formView = self.formView as! SignUpFormView

        let user = PFUser()

        user.username = formView.cells.username.textField.text
        user.password = formView.cells.password.textField.text
        user.email = formView.cells.email.textField.text
        user["firstName"] = formView.cells.firstName.textField.text
        user["lastName"] = formView.cells.lastName.textField.text

        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        user.promiseSignUp()
            .then { user -> Void in
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
                
                self.dismissViewControllerAnimated(true, completion: nil)

            }.catch(policy: .AllErrors) { (error) -> Void in
                PKHUD.sharedHUD.hide()

                var message: String

                switch error.code {
                case 202:
                    message = "Username taken. Please try another username."
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
}