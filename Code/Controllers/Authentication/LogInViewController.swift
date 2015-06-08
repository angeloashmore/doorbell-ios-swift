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

class LogInViewController: KHAFormViewController, FormProtocol {

    // MARK: Class Properties


    // MARK: Instance Properties
    let formView = LogInFormView()
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

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formView.headerForSection(section)
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return formView.footerForSection(section)
    }


    // MARK: ValidatorDelegate Protocol Methods
    func validationSuccessful() {
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

    func validationFailed(errors: [UITextField : ValidationError]) {
        log(errors, forLevel: .Error)

        let alertController = UIAlertController(title: "Error", message: "Please re-check all fields and try again", preferredStyle: .Alert)

        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }


    // MARK: Methods
    func configureUI() {
        title = "Log In"

        let submitButton = UIBarButtonItem(title: "Submit", style: .Done, target: self, action: "submit")
        navigationItem.rightBarButtonItem = submitButton
    }

    func configureCells() {
        formView.cells.signUp.button.addTarget(self, action: "handleSignUpButton", forControlEvents: UIControlEvents.TouchUpInside)
    }

    func configureValidator() {
        validator.registerField(formView.cells.username.textField, rules: [RequiredRule()])
        validator.registerField(formView.cells.password.textField, rules: [RequiredRule()])
    }

    func handleSignUpButton() {
        performSegueWithIdentifier("SignUp", sender: nil)
    }

    func submit() {
        validator.validate(self)
    }
}
