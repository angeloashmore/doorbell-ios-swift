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

        formView.formRowDescriptors[SignUpFormView.Tags.firstName]!.configuration[FormRowDescriptor.Configuration.Validator] = Validators.firstName
        formView.formRowDescriptors[SignUpFormView.Tags.lastName]!.configuration[FormRowDescriptor.Configuration.Validator] = Validators.lastName
        formView.formRowDescriptors[SignUpFormView.Tags.email]!.configuration[FormRowDescriptor.Configuration.Validator] = Validators.email
        formView.formRowDescriptors[SignUpFormView.Tags.username]!.configuration[FormRowDescriptor.Configuration.Validator] = Validators.username
        formView.formRowDescriptors[SignUpFormView.Tags.password]!.configuration[FormRowDescriptor.Configuration.Validator] = Validators.password
//        formView.formRowDescriptors[SignUpFormView.Tags.passwordVerify]!.configuration[FormRowDescriptor.Configuration.Validator] = Validators.passwordVerify

        self.form = formView.form
    }


    // MARK: Methods
    func submit() {
        if form.validateFormWithHonour() {
            signUp()
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please re-check all fields and try again", preferredStyle: .Alert)

            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)

            self.presentViewController(alertController, animated: true, completion: nil)
        }
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

                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)

                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(OKAction)

                self.presentViewController(alertController, animated: true, completion: nil)
            }
    }
}