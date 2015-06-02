//
//  SettingsEditProfileFormView.swift
//  Doorbell
//
//  Created by Angelo on 6/2/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import SwiftForms

public class SettingsEditProfileFormView {
    // MARK: Class Properties
    struct Tags {
        static let firstName = "fistName"
        static let lastName = "lastName"
        static let email = "email"
    }

    private struct VisualConstraints {
        static let textFieldRow: VisualConstraintsClosure = { row in
            return ["H:|-16-[titleLabel(90)]-[textField]-16-|"]
        }
    }

    struct FormRowDescriptors {
        var firstName: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: Tags.firstName, rowType: FormRowType.Name, title: "First Name", placeholder: "First")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }()

        var lastName: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: Tags.lastName, rowType: FormRowType.Name, title: "Last Name", placeholder: "Last")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }()

        var email: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: Tags.email, rowType: FormRowType.Email, title: "Email", placeholder: "name@example.com")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }()
    }


    // MARK: Instance Properties
    var formRowDescriptors = FormRowDescriptors()

    var form: FormDescriptor {
        let form = FormDescriptor()

        let section = FormSectionDescriptor()
        section.addRow(formRowDescriptors.firstName)
        section.addRow(formRowDescriptors.lastName)
        section.addRow(formRowDescriptors.email)

        form.sections = [section]

        return form
    }


    // MARK: Methods
}