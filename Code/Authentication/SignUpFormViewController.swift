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

class SignUpFormViewController: FormViewController {

    // MARK: Class Properties
    private struct Tags {
        static let name = "name"
        static let email = "email"
        static let username = "username"
        static let password = "password"
        static let passwordVerify = "passwordVerify"
    }

    private struct Validators {
        static let name = Validator().addRule(NotEmpty())
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

        let submitButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = submitButton
    }


    // MARK: Form Configuration
    private func loadForm() {
        let form = FormDescriptor()

        form.title = "Sign Up"

        let section1 = FormSectionDescriptor()

        var row = FormRowDescriptor(tag: Tags.name, rowType: FormRowType.Name, title: "Full Name", placeholder: "First Last")
        section1.addRow(row)

        row = FormRowDescriptor(tag: Tags.email, rowType: FormRowType.Email, title: "Email", placeholder: "name@example.com")
        section1.addRow(row)

        let section2 = FormSectionDescriptor()
        section2.footerTitle = "Your password must be at least 8 characters and include a number, an uppercase letter, and a lowercase letter."

        row = FormRowDescriptor(tag: Tags.username, rowType: FormRowType.Name, title: "Username", placeholder: "Required")
        section2.addRow(row)

        row = FormRowDescriptor(tag: Tags.password, rowType: FormRowType.Password, title: "Password", placeholder: "Required")
        section2.addRow(row)

        row = FormRowDescriptor(tag: Tags.passwordVerify, rowType: FormRowType.Password, title: "Verify", placeholder: "Retype password")
        section2.addRow(row)

        form.sections = [section1, section2]

        self.form = form
    }


    // MARK: Methods
    func submit() {
        let validationResults = validate()

        if validationResults.isValid {
            signUp()
        } else {
            let alert = UIAlertView(title: "Error", message: "Please check your credentials and try again.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }

    func validate() -> (isValid: Bool, invalidRules: [String: Array<Rule>]) {
        let values = form.formValues()
        var results = Dictionary<String, (isValid: Bool, invalidRules: Array<Rule>)>()

        results[Tags.name] = Validators.name.assert(values[Tags.name] as? String ?? "")
        results[Tags.email] = Validators.email.assert(values[Tags.email] as? String ?? "")
        results[Tags.username] = Validators.username.assert(values[Tags.username] as? String ?? "")
        results[Tags.password] = Validators.password.assert(values[Tags.password] as? String ?? "")
//        results[Tags.passwordVerify] = Validators.passwordVerify.assert(values[Tags.passwordVerify] as? String ?? "")

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
        let username = formValues[Tags.username] as? String ?? ""
        let password = formValues[Tags.password] as? String ?? ""
        let email = formValues[Tags.email] as? String ?? ""
        let name = formValues[Tags.name] as? String ?? ""
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        user["name"] = name

        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                    PKHUD.sharedHUD.hide(afterDelay: 1.0)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                PKHUD.sharedHUD.hide()

                var message: String

                switch error!.code {
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
}