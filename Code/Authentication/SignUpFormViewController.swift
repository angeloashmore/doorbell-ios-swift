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
import XLForm

class SignUpFormViewController: XLFormViewController {

    private enum Tags: String {
        case Name = "Name"
        case Email = "Email"
        case Username = "Username"
        case Password = "Password"
        case PasswordVerify = "PasswordVerify"
    }


    // MARK: Class Properties


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: "handleFormSubmit")
        self.navigationItem.rightBarButtonItem = nextButton
    }


    // MARK: Form Configuration
    func initializeForm() {
        let form: XLFormDescriptor
        var section: XLFormSectionDescriptor
        var row: XLFormRowDescriptor

        form = XLFormDescriptor()

        // New Section
        section = XLFormSectionDescriptor.formSectionWithTitle("Account Credentials")
        form.addFormSection(section)

        // Full Name
        row = XLFormRowDescriptor(tag: Tags.Name.rawValue, rowType: XLFormRowDescriptorTypeText, title: "Full Name")
        row.cellConfigAtConfigure["textField.placeholder"] = "First Last"
        row.required = true
        section.addFormRow(row)

        // Email
        row = XLFormRowDescriptor(tag: Tags.Email.rawValue, rowType: XLFormRowDescriptorTypeEmail, title: "Email")
        row.cellConfigAtConfigure["textField.placeholder"] = "name@example.com"
        row.required = true
        section.addFormRow(row)

        // New Section
        section = XLFormSectionDescriptor.formSection()
        section.footerTitle = "Your password must be at least 8 characters and include a number, an uppercase letter, and a lowercase letter."
        form.addFormSection(section)

        // Username
        row = XLFormRowDescriptor(tag: Tags.Username.rawValue, rowType: XLFormRowDescriptorTypeText, title: "Username")
        row.cellConfigAtConfigure["textField.placeholder"] = "Required"
        row.required = true
        section.addFormRow(row)

        // Password
        row = XLFormRowDescriptor(tag: Tags.Password.rawValue, rowType: XLFormRowDescriptorTypePassword, title: "Password")
        row.cellConfigAtConfigure["textField.placeholder"] = "Required"
        row.required = true
        section.addFormRow(row)

        // Password Verify
        row = XLFormRowDescriptor(tag: Tags.PasswordVerify.rawValue, rowType: XLFormRowDescriptorTypePassword, title: "Verify")
        row.cellConfigAtConfigure["textField.placeholder"] = "Retype password"
        row.required = true
        section.addFormRow(row)

        self.form = form
    }


    // MARK: Methods
    func handleFormSubmit() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()

//        // Create the user
//        var user = PFUser()
//        user.username = self.usernameField.text
//        user.password = self.passwordField.text
//        user.email = self.emailAddressField.text
//        user["name"] = self.nameField.text
//
//        user.signUpInBackgroundWithBlock {
//            (succeeded: Bool, error: NSError?) -> Void in
//            if error == nil {
//                dispatch_async(dispatch_get_main_queue()) {
//                    PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
//                    PKHUD.sharedHUD.hide(afterDelay: 1.0)
////                    self.performSegueWithIdentifier("signInToNavigation", sender: self)
//                }
//            } else {
//                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Error", image: PKHUDAssets.crossImage)
//                PKHUD.sharedHUD.hide(afterDelay: 1.0)
//            }
//        }
    }
   
}