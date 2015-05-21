//
//  LoginTableViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/20/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func logInButton(sender: UIBarButtonItem) {
        self.logIn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.delegate = self
        passwordField.delegate = self
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case self.usernameField:
            self.passwordField.becomeFirstResponder()

        case self.passwordField:
            self.logIn()

        default:
            self.view.endEditing(true)
            return false
        }

        return true
    }

    func logIn() {
        self.view.endEditing(true)
        println("login the user here")
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let signUpController = segue.destinationViewController as! SignUpTableViewController
        signUpController.username = self.usernameField.text
        signUpController.password = self.passwordField.text
    }

}
