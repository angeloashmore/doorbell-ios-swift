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
        }()
    ]

    var form: FormDescriptor {
        let form = FormDescriptor()

        let section = FormSectionDescriptor()
        section.addRow(formRowDescriptors[Tags.firstName]!)
        section.addRow(formRowDescriptors[Tags.lastName]!)
        section.addRow(formRowDescriptors[Tags.email]!)

        form.sections = [section]

        return form
    }
}