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
import SwiftForms
import Honour

class SignUpViewController: FormViewController {

    // MARK: Class Properties
    private struct Validators {
        static let firstName = Validator().addRule(NotEmpty())
        static let lastName = Validator().addRule(NotEmpty())
        static let email = Validator().addRule(NotEmpty()).addRule(Email())
        static let username = Validator().addRule(NotEmpty()).addRule(Length(min: 3))
        static let password = Validator().addRule(NotEmpty()).addRule(Regex("^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,}$")) // 8 char, 1 num, 1 uppercase, 1 lowercase
//        static let passwordVerify = Validator().addRule(Regex("^\(self.form.formValues()[Tags.password])$"))
    }


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sign Up"

        let submitButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = submitButton
    }


    // MARK: Form Configuration
    private func loadForm() {
        let formView = SignUpFormView()

        self.form = formView.form
    }


    // MARK: Methods
    func submit() {
        let validationResults = validate()

        if validationResults.isValid {
            signUp()
        } else {
            let alert = UIAlertView(title: "Error", message: "Please re-check all fields and try again.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }

    func validate() -> (isValid: Bool, invalidRules: [String: Array<Rule>]) {
        let values = form.formValues()
        var results = Dictionary<String, (isValid: Bool, invalidRules: Array<Rule>)>()

        results[SignUpFormView.Tags.firstName] = Validators.firstName.assert(values[SignUpFormView.Tags.firstName] as? String ?? "")
        results[SignUpFormView.Tags.lastName] = Validators.lastName.assert(values[SignUpFormView.Tags.lastName] as? String ?? "")
        results[SignUpFormView.Tags.email] = Validators.email.assert(values[SignUpFormView.Tags.email] as? String ?? "")
        results[SignUpFormView.Tags.username] = Validators.username.assert(values[SignUpFormView.Tags.username] as? String ?? "")
        results[SignUpFormView.Tags.password] = Validators.password.assert(values[SignUpFormView.Tags.password] as? String ?? "")
//        results[SignUpFormView.Tags.passwordVerify] = Validators.passwordVerify.assert(values[SignUpFormView.Tags.passwordVerify] as? String ?? "")

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

    func signUp() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        
        let formValues = form.formValues()
        let username = formValues[SignUpFormView.Tags.username] as? String ?? ""
        let password = formValues[SignUpFormView.Tags.password] as? String ?? ""
        let email = formValues[SignUpFormView.Tags.email] as? String ?? ""
        let firstName = formValues[SignUpFormView.Tags.firstName] as? String ?? ""
        let lastName = formValues[SignUpFormView.Tags.lastName] as? String ?? ""
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        user["firstName"] = firstName
        user["lastName"] = lastName

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

                let alert = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
    }
}