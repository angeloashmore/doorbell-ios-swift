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
    private struct Tags {
        static let firstName = "fistName"
        static let lastName = "lastName"
        static let email = "email"
    }

    private struct Validators {
        static let firstName = Validator().addRule(NotEmpty())
        static let lastName = Validator().addRule(NotEmpty())
        static let email = Validator().addRule(NotEmpty()).addRule(Email())
    }

    private struct VisualConstraints {
        static let textFieldRow: VisualConstraintsClosure = { row in
            return ["H:|-16-[titleLabel(90)]-[textField]-16-|"]
        }
    }


    // MARK: Life-Cycle Methods
    override func viewDidLoad() {
        self.title = "Edit Profile"
        
        self.loadForm()

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelButton

        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = saveButton
    }


    // MARK: Methods
    private func loadForm() {
        let form = FormDescriptor()
        var row: FormRowDescriptor

        form.title = "Edit Profile"

        let section1 = FormSectionDescriptor()

        row = FormRowDescriptor(tag: Tags.firstName, rowType: FormRowType.Name, title: "First Name", placeholder: "First")
        row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
        row.value = PFUser.currentUser()?.objectForKey("firstName") as? String ?? ""
        section1.addRow(row)

        row = FormRowDescriptor(tag: Tags.lastName, rowType: FormRowType.Name, title: "Last Name", placeholder: "Last")
        row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
        row.value = PFUser.currentUser()?.objectForKey("lastName") as? String ?? ""
        section1.addRow(row)

        row = FormRowDescriptor(tag: Tags.email, rowType: FormRowType.Email, title: "Email", placeholder: "name@example.com")
        row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
        row.value = PFUser.currentUser()?.email
        section1.addRow(row)

        form.sections = [section1]

        self.form = form
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

        results[Tags.firstName] = Validators.firstName.assert(values[Tags.firstName] as? String ?? "")
        results[Tags.lastName] = Validators.lastName.assert(values[Tags.lastName] as? String ?? "")
        results[Tags.email] = Validators.email.assert(values[Tags.email] as? String ?? "")

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