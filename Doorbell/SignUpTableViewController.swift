//
//  SignUpTableViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/20/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import PKHUD
import SwiftValidator

class SignUpTableViewController: UITableViewController, UITextFieldDelegate, ValidationDelegate {

    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordVerifyLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordVerifyField: UITextField!


    // MARK: Class Properties
    var username: String = ""
    var password: String = ""
    let validator = Validator()


    // MARK: Life-Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add next button to UINavigationBar
        self.addNextBarButtonItem()

        // Set text field delegates.
        self.nameField.delegate = self
        self.emailAddressField.delegate = self
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.passwordVerifyField.delegate = self

        // Set predefined username and password.
        self.usernameField.text = self.username
        self.passwordField.text = self.password

        // Open keyboard for name field.
        self.nameField.becomeFirstResponder()

        // Register validators.
        validator.registerField(nameField, errorLabel: nameLabel, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(emailAddressField, errorLabel: emailAddressLabel, rules: [RequiredRule(), EmailRule()])
        validator.registerField(usernameField, errorLabel: usernameLabel, rules: [RequiredRule(), MinLengthRule(length: 3)])
        validator.registerField(passwordField, errorLabel: passwordLabel, rules: [RequiredRule(), PasswordRule(regex: "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,}$")]) // min 8 characters, 1 uppercase, 1 lowercase
        validator.registerField(passwordVerifyField, errorLabel: passwordVerifyLabel, rules: [RequiredRule(), ConfirmationRule(confirmField: passwordField)])
    }


    // MARK: Methods
    func addNextBarButtonItem() {
        var nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: "formSubmitHandler")
        self.navigationItem.rightBarButtonItem = nextButton
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.nameField {
            self.emailAddressField.becomeFirstResponder()
        } else if textField == self.emailAddressField {
            self.usernameField.becomeFirstResponder()
        } else if textField == self.usernameField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.passwordVerifyField.becomeFirstResponder()
        } else if textField == self.passwordVerifyField {
            self.formSubmitHandler()
        }

        return false
    }

    func formSubmitHandler() {
        self.view.endEditing(true)

        nameLabel.textColor = UIColor.blackColor()
        emailAddressLabel.textColor = UIColor.blackColor()
        usernameLabel.textColor = UIColor.blackColor()
        passwordLabel.textColor = UIColor.blackColor()
        passwordVerifyLabel.textColor = UIColor.blackColor()

        self.validator.validate(self)
    }

    func validationSuccessful() {
        signUpUser()
    }

    func validationFailed(errors: [UITextField : ValidationError]) {
        for (field, error) in validator.errors {
            error.errorLabel?.textColor = UIColor.redColor()
        }
    }

    func signUpUser() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()

        // Create the user
        var user = PFUser()
        user.username = self.usernameField.text
        user.password = self.passwordField.text
        user.email = self.emailAddressField.text
        user["name"] = self.nameField.text

        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                    PKHUD.sharedHUD.hide(afterDelay: 1.0)
//                    self.performSegueWithIdentifier("signInToNavigation", sender: self)
                }
            } else {
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Error", image: PKHUDAssets.crossImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
            }
        }
    }

}
