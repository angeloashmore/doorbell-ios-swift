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
import LayerKit

class LogInFormViewController: FormViewController, FormViewControllerDelegate {

    // MARK: Class Properties
    private struct Tags {
        static let username = "username"
        static let password = "password"
        static let signUp = "signUp"
    }

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

        self.delegate = self

        let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Done, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = submitButton
    }


    // MARK: Methods
    private func loadForm() {
        let form = FormDescriptor()

        form.title = "Log In"

        let section1 = FormSectionDescriptor()
        section1.headerTitle = "Account Credentials"

        var row = FormRowDescriptor(tag: Tags.username, rowType: FormRowType.Name, title: "Username", placeholder: "Username")
        row.title = nil
        section1.addRow(row)

        row = FormRowDescriptor(tag: Tags.password, rowType: FormRowType.Password, title: "Password", placeholder: "Password")
        row.title = nil
        section1.addRow(row)

        let section2 = FormSectionDescriptor()
        section2.footerTitle = "Join Doorbell now to start chatting with your clients. The first 3 months are FREE and then only $10 a month."

        row = FormRowDescriptor(tag: Tags.signUp, rowType: FormRowType.Button, title: "Create a new Doorbell account")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["titleLabel.textAlignment": NSTextAlignment.Left.rawValue, "titleLabel.textColor": UIColor(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1.0)]
        section2.addRow(row)

        form.sections = [section1, section2]

        self.form = form
    }

    func submit() {
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

        results[Tags.username] = Validators.username.assert(values[Tags.username] as? String ?? "")
        results[Tags.password] = Validators.password.assert(values[Tags.password] as? String ?? "")

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
        let username = formValues[Tags.username] as? String ?? ""
        let password = formValues[Tags.password] as? String ?? ""

        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // User exists
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)

                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                PKHUD.sharedHUD.hide()

                var message: String

                switch error!.code {
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


    /// MARK: FormViewControllerDelegate
    
    func formViewController(controller: FormViewController, didSelectRowDescriptor rowDescriptor: FormRowDescriptor) {
        switch rowDescriptor.tag {
        case Tags.signUp:
            self.performSegueWithIdentifier("SignUpSegue", sender: self)
        default:
            break
        }
    }
}
