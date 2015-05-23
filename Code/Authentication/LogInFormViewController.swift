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
import XLForm

class LogInFormViewController: XLFormViewController {

    private enum Tags: String {
        case Username = "Username"
        case Password = "Password"
        case SignUp = "SignUp"
    }


    // MARK: Class Properties


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Done, target: self, action: "handleFormSubmit")
        self.navigationItem.rightBarButtonItem = submitButton
    }


    // MARK: Form Configuration
    func initializeForm() {
        let form: XLFormDescriptor
        var section: XLFormSectionDescriptor
        var row: XLFormRowDescriptor

        form = XLFormDescriptor()

        section = XLFormSectionDescriptor.formSectionWithTitle("Account Credentials")
        form.addFormSection(section)

        // Username
        row = XLFormRowDescriptor(tag: Tags.Username.rawValue, rowType: XLFormRowDescriptorTypeText, title: "Username")
        row.required = true
        section.addFormRow(row)

        // Password
        row = XLFormRowDescriptor(tag: Tags.Password.rawValue, rowType: XLFormRowDescriptorTypePassword, title: "Password")
        row.required = true
        section.addFormRow(row)

        // New Section
        section = XLFormSectionDescriptor.formSection()
        section.footerTitle = "Join Doorbell now to start chatting with your clients. The first 3 months are FREE and then only $10 a month."
        form.addFormSection(section)

        // Create account button
        row = XLFormRowDescriptor(tag: Tags.SignUp.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Create a new Doorbell account")
        row.action.formSegueIdenfifier = "SignUp"
        section.addFormRow(row)

        self.form = form
    }


    // MARK: Methods
    func handleFormSubmit() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()

//        PFUser.logInWithUsernameInBackground(self.usernameField.text, password: self.passwordField.text) {
//            (user: PFUser?, error: NSError?) -> Void in
//            if user != nil {
//                // User exists
//                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
//                PKHUD.sharedHUD.hide(afterDelay: 1.0)
//
////                let applicationStoryboard = UIStoryboard(name: "Application", bundle: nil)
////                let initialViewController = applicationStoryboard.instantiateInitialViewController() as! UIViewController
////
////                self.navigationController?.presentViewController(initialViewController, animated: true, completion: nil)
//            } else {
//                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Error", image: PKHUDAssets.crossImage)
//                PKHUD.sharedHUD.hide(afterDelay: 1.0)
//            }
//        }
    }
   
}
