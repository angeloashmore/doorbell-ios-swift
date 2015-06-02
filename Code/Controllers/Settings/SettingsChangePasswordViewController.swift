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
//        static let passwordVerify = Validator().addRule(Regex("^\(self.form.formValues()[Tags.password])$"))
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

        self.form = formView.form
    }

    func submit() {
        self.view.endEditing(true)
        
        let validationResults = validate()

        if validationResults.isValid {
            cancel()
        } else {
            let alert = UIAlertView(title: "Error", message: "Please re-check all fields and try again.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }

    func validate() -> (isValid: Bool, invalidRules: [String: Array<Rule>]) {
        let values = form.formValues()
        var results = Dictionary<String, (isValid: Bool, invalidRules: Array<Rule>)>()

        results[SettingsChangePasswordFormView.Tags.currentPassword] = Validators.currentPassword.assert(values[SettingsChangePasswordFormView.Tags.currentPassword] as? String ?? "")
        results[SettingsChangePasswordFormView.Tags.newPassword] = Validators.newPassword.assert(values[SettingsChangePasswordFormView.Tags.newPassword] as? String ?? "")
//        results[SettingsChangePasswordFormView.Tags.newPasswordVerify] = Validators.newPasswordVerify.assert(values[SettingsChangePasswordFormView.Tags.newPasswordVerify] as? String ?? "")

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

    func cancel() {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
