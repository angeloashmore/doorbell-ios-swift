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
import SwiftFormsHonour
import Honour

class SignUpViewController: FormViewController {

    // MARK: Class Properties


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

        formView.formRowDescriptors[SignUpFormView.Tags.firstName]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty())
        } as ValidatorClosure

        formView.formRowDescriptors[SignUpFormView.Tags.lastName]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty())
        } as ValidatorClosure

        formView.formRowDescriptors[SignUpFormView.Tags.email]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty()).addRule(Email())
        } as ValidatorClosure

        formView.formRowDescriptors[SignUpFormView.Tags.username]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty()).addRule(Length(min: 3))
        } as ValidatorClosure

        formView.formRowDescriptors[SignUpFormView.Tags.password]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty()).addRule(Regex("^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,}$")) // 8 char, 1 num, 1 uppercase, 1 lowercase
        } as ValidatorClosure

        formView.formRowDescriptors[SignUpFormView.Tags.passwordVerify]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(Regex("^\(self.valueForTag(SignUpFormView.Tags.password))$"))
        } as ValidatorClosure

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