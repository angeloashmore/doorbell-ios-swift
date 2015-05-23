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

class SignUpFormViewController: FormViewController, FormViewControllerDelegate {

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
        self.loadForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        let submitButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = submitButton
    }


    // MARK: Form Configuration
    private func loadForm() {
        let form = FormDescriptor()

        form.title = "Sign Up"

        let section1 = FormSectionDescriptor()

        var row = FormRowDescriptor(tag: Tags.Name.rawValue, rowType: FormRowType.Name, title: "Full Name", placeholder: "First Last")
        section1.addRow(row)

        row = FormRowDescriptor(tag: Tags.Email.rawValue, rowType: FormRowType.Email, title: "Email", placeholder: "name@example.com")
        section1.addRow(row)

        let section2 = FormSectionDescriptor()
        section2.footerTitle = "Your password must be at least 8 characters and include a number, an uppercase letter, and a lowercase letter."

        row = FormRowDescriptor(tag: Tags.Username.rawValue, rowType: FormRowType.Name, title: "Username", placeholder: "Required")
        section2.addRow(row)

        row = FormRowDescriptor(tag: Tags.Password.rawValue, rowType: FormRowType.Password, title: "Password", placeholder: "Required")
        section2.addRow(row)

        row = FormRowDescriptor(tag: Tags.PasswordVerify.rawValue, rowType: FormRowType.Password, title: "Verify", placeholder: "Retype password")
        section2.addRow(row)

        form.sections = [section1, section2]

        self.form = form
    }


    // MARK: Methods
    func submit() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        
        let formValues = form.formValues()
        let username = formValues[Tags.Username.rawValue] as? String
        let password = formValues[Tags.Password.rawValue] as? String
        let email = formValues[Tags.Email.rawValue] as? String
        let name = formValues[Tags.Name.rawValue] as? String
        
        let user = PFUser()
        if username != nil { user.username = username }
        if password != nil { user.password = password }
        if email != nil { user.email = email }
        if name != nil { user["name"] = name }

        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                    PKHUD.sharedHUD.hide(afterDelay: 1.0)
                }
            } else {
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Error", image: PKHUDAssets.crossImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
            }
        }
    }


    /// MARK: FormViewControllerDelegate
    
    func formViewController(controller: FormViewController, didSelectRowDescriptor rowDescriptor: FormRowDescriptor) {
        switch rowDescriptor.tag {
        default:
            break
        }
    }
}