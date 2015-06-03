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
import SwiftForms
import Honour

class LogInViewController: FormViewController {

    // MARK: Class Properties
    private struct Validators {
        static let username = Validator().addRule(NotEmpty())
        static let password = Validator().addRule(NotEmpty())
    }


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.loadForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Log In"

        let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Done, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = submitButton
    }


    // MARK: Methods
    private func loadForm() {
        let formView = LogInFormView()

        formView.formRowDescriptors[LogInFormView.Tags.username]!.configuration[FormRowDescriptor.Configuration.Validator] = Validators.password

        formView.formRowDescriptors[LogInFormView.Tags.password]!.configuration[FormRowDescriptor.Configuration.Validator] = Validators.password

        formView.formRowDescriptors[LogInFormView.Tags.signUp]!.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.performSegueWithIdentifier("SignUpSegue", sender: nil)
        } as DidSelectClosure

        self.form = formView.form
    }

    func submit() {
        self.view.endEditing(true)
        
        let validationResults = validate()

        if validationResults.isValid {
            logIn()
        } else {
            let alert = UIAlertView(title: "Error", message: "Please re-check all fields and try again.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }

    func validate() -> (isValid: Bool, invalidRules: [String: Array<Rule>]) {
        let values = form.formValues()
        var results = Dictionary<String, (isValid: Bool, invalidRules: Array<Rule>)>()

        results[LogInFormView.Tags.username] = Validators.username.assert(values[LogInFormView.Tags.username] as? String ?? "")
        results[LogInFormView.Tags.password] = Validators.password.assert(values[LogInFormView.Tags.password] as? String ?? "")

        var isValid = true
        var invalidRules = Dictionary<String, Array<Rule>>()
        for (key, result) in results {
            if !result.isValid {
                isValid = false
                invalidRules[key] = result.invalidRules
            }
        }

        return (isValid, invalidRules)
    }

    func logIn() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()

        let formValues = form.formValues()
        let username = formValues[LogInFormView.Tags.username] as? String ?? ""
        let password = formValues[LogInFormView.Tags.password] as? String ?? ""

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

                let alert = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
        }
    }
}
