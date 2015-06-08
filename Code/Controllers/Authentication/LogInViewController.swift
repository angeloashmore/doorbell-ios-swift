//
//  LoginFormViewController.swift
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

class LogInViewController: FormViewController {

    // MARK: Class Properties


    // MARK: Instance Properties


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)

        formView = LogInFormView()
    }


    // MARK: FormViewController Methods
    override func configureUI() {
        title = "Log In"

        let submitButton = UIBarButtonItem(title: "Submit", style: .Done, target: self, action: "submit")
        navigationItem.rightBarButtonItem = submitButton
    }

    override func configureCells() {
        let formView = self.formView as! LogInFormView

        formView.cells.signUp.button.addTarget(self, action: "handleSignUpButton", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func configureValidator() {
        let formView = self.formView as! LogInFormView

        validator.registerField(formView.cells.username.textField, rules: [RequiredRule()])
        validator.registerField(formView.cells.password.textField, rules: [RequiredRule()])
    }

    override func validationSuccessful() {
        let formView = self.formView as! LogInFormView

        let username = formView.cells.username.textField.text
        let password = formView.cells.password.textField.text

        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        PFUser.promiseLogInWithUsername(username, password: password)
            .then { user -> Void in
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)

                self.dismissViewControllerAnimated(true, completion: nil)

            }.catch(policy: .AllErrors) { (error) -> Void in
                PKHUD.sharedHUD.hide()

                var message: String

                switch error.code {
                case 101:
                    message = "Incorrect username or password."
                default:
                    message = "An error occured. Please try again."
                }

                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)

                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(OKAction)

                self.presentViewController(alertController, animated: true, completion: nil)
            }
    }


    // MARK: Methods
    func handleSignUpButton() {
        performSegueWithIdentifier("SignUp", sender: nil)
    }
}
