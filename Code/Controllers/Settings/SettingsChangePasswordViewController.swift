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
import SwiftForms
import Honour

class SettingsChangePasswordViewController: FormViewController {

    // MARK: Class Properties
    private struct Validators {
        static let currentPassword = Validator().addRule(NotEmpty())
        static let newPassword = Validator().addRule(NotEmpty()).addRule(Regex("^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,}$")) // 8 char, 1 num, 1 uppercase, 1 lowercase
//        static let newPasswordVerify = Validator().addRule(Regex("^\(self.form.formValues()[Tags.password])$"))
    }


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.loadForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Change Password"

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelButton

        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = saveButton
    }


    // MARK: Methods
    private func loadForm() {
        let formView = SettingsChangePasswordFormView()

        formView.formRowDescriptors[SettingsChangePasswordFormView.Tags.currentPassword]!.configuration[FormRowDescriptor.Configuration.Validator] = Validators.currentPassword
        formView.formRowDescriptors[SettingsChangePasswordFormView.Tags.newPassword]!.configuration[FormRowDescriptor.Configuration.Validator] = Validators.newPassword
//        formView.formRowDescriptors[SettingsChangePasswordFormView.Tags.newPasswordVerify]!.configuration[FormRowDescriptor.Configuration.Validator] = Validators.newPasswordVerify

        self.form = formView.form
    }

    func submit() {
        self.view.endEditing(true)
        
        if form.validateFormWithHonour() {
            updateUser()
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please re-check all fields and try again", preferredStyle: .Alert)

            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)

            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    func updateUser() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        
        let formValues = form.formValues()
        let password = formValues[SettingsChangePasswordFormView.Tags.newPassword] as? String ?? ""

        let user = PFUser.currentUser()!
        user.setValue(password, forKey: "password")

        user.promiseSave()
            .then { user -> Void in
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
                self.cancel()

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

        PFUser.promiseLogOut()
            .then { _ in
                return LayerClient.sharedClient.deauthenticateWithLayer()

            }.then { _ -> Void in
                PKHUD.sharedHUD.hide()
                self.tabBarController?.dismissViewControllerAnimated(true, completion: nil)

            }
    }

    func cancel() {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
