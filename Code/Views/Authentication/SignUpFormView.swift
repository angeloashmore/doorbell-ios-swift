//
//  SignUpFormView.swift
//  Doorbell
//
//  Created by Angelo on 6/2/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import SwiftForms

public class SignUpFormView {
    // MARK: Class Properties
    struct Tags {
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let email = "email"
        static let username = "username"
        static let password = "password"
        static let passwordVerify = "passwordVerify"
    }

    private struct VisualConstraints {
        static let textFieldRow: VisualConstraintsClosure = { row in
            return ["H:|-16-[titleLabel(90)]-[textField]-16-|"]
        }
    }


    // MARK: Instance Properties
    var formRowDescriptors: [String: FormRowDescriptor] = [
        Tags.firstName: {
            let row = FormRowDescriptor(tag: Tags.firstName, rowType: FormRowType.Name, title: "First Name", placeholder: "First")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }(),

        Tags.lastName: {
            let row = FormRowDescriptor(tag: Tags.lastName, rowType: FormRowType.Name, title: "Last Name", placeholder: "Last")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }(),

        Tags.email: {
            let row = FormRowDescriptor(tag: Tags.email, rowType: FormRowType.Email, title: "Email", placeholder: "name@example.com")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }(),

        Tags.username: {
            let row = FormRowDescriptor(tag: Tags.username, rowType: FormRowType.Name, title: "Username", placeholder: "Required")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }(),

        Tags.password: {
            let row = FormRowDescriptor(tag: Tags.password, rowType: FormRowType.Password, title: "Password", placeholder: "Required")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }(),

        Tags.passwordVerify: {
            let row = FormRowDescriptor(tag: Tags.passwordVerify, rowType: FormRowType.Password, title: "Verify", placeholder: "Retype password")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }()
    ]

    var form: FormDescriptor {
        let form = FormDescriptor()

        let personalDetailsSection = FormSectionDescriptor()
        personalDetailsSection.addRow(formRowDescriptors[Tags.firstName]!)
        personalDetailsSection.addRow(formRowDescriptors[Tags.lastName]!)
        personalDetailsSection.addRow(formRowDescriptors[Tags.email]!)

        let credentialsSection = FormSectionDescriptor()
        credentialsSection.addRow(formRowDescriptors[Tags.username]!)
        credentialsSection.addRow(formRowDescriptors[Tags.password]!)
        credentialsSection.addRow(formRowDescriptors[Tags.passwordVerify]!)
        credentialsSection.footerTitle = "Your password must be at least 8 characters and include a number, an uppercase letter, and a lowercase letter."

        form.sections = [personalDetailsSection, credentialsSection]

        return form
    }
}
