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

class EditProfileViewController: FormViewController {

    // MARK: Class Properties
    private struct Tags {
        static let name = "name"
    }

    private struct Validators {
        static let name = Validator().addRule(NotEmpty())
    }


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelButton

        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = saveButton
    }


    // MARK: Methods
    private func loadForm() {
        let form = FormDescriptor()

        form.title = "Edit Profile"

        let section1 = FormSectionDescriptor()

        var row = FormRowDescriptor(tag: Tags.name, rowType: FormRowType.Name, title: "Full Name", placeholder: "First Last")
        row.value = PFUser.currentUser()?.objectForKey("name") as? String ?? ""
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

        results[Tags.name] = Validators.name.assert(values[Tags.name] as? String ?? "")

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