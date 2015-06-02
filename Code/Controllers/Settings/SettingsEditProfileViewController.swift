//
//  EditProfileViewController.swift
//  Doorbell
//
//  Created by Angelo on 5/23/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import PKHUD
import SwiftForms
import Honour

class SettingsEditProfileViewController: FormViewController {

    // MARK: Class Properties
    private struct Validators {
        static let firstName = Validator().addRule(NotEmpty())
        static let lastName = Validator().addRule(NotEmpty())
        static let email = Validator().addRule(NotEmpty()).addRule(Email())
    }


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Profile"

        self.loadForm()

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelButton

        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = saveButton
    }


    // MARK: Methods
    private func loadForm() {
        let formView = SettingsEditProfileFormView()

        formView.formRowDescriptors.firstName.value = PFUser.currentUser()?.objectForKey("firstName") as? String ?? ""
        formView.formRowDescriptors.lastName.value = PFUser.currentUser()?.objectForKey("lastName") as? String ?? ""
        formView.formRowDescriptors.email.value = PFUser.currentUser()?.objectForKey("email") as? String ?? ""

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

        results[SettingsEditProfileFormView.Tags.firstName] = Validators.firstName.assert(values[SettingsEditProfileFormView.Tags.firstName] as? String ?? "")
        results[SettingsEditProfileFormView.Tags.lastName] = Validators.lastName.assert(values[SettingsEditProfileFormView.Tags.lastName] as? String ?? "")
        results[SettingsEditProfileFormView.Tags.email] = Validators.email.assert(values[SettingsEditProfileFormView.Tags.email] as? String ?? "")

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