//
//  SettingsChangePasswordFormView.swift
//  Doorbell
//
//  Created by Angelo on 6/2/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import SwiftForms

public class SettingsChangePasswordFormView {
    // MARK: Class Properties
    struct Tags {
        static let currentPassword = "currentPassword"
        static let newPassword = "newPassword"
        static let newPasswordVerify = "newPasswordVerify"
    }

    private struct VisualConstraints {
        static let textFieldRow: VisualConstraintsClosure = { row in
            return ["H:|-16-[titleLabel(85)]-[textField]-16-|"]
        }
    }


    // MARK: Instance Properties
    var formRowDescriptors: [String: FormRowDescriptor] = [
        Tags.currentPassword: {
            let row = FormRowDescriptor(tag: Tags.currentPassword, rowType: FormRowType.Password, title: "Password", placeholder: "Current password")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }(),

        Tags.newPassword: {
            let row = FormRowDescriptor(tag: Tags.newPassword, rowType: FormRowType.Password, title: "Password", placeholder: "New password")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }(),

        Tags.newPasswordVerify: {
            let row = FormRowDescriptor(tag: Tags.newPasswordVerify, rowType: FormRowType.Password, title: "Verify", placeholder: "Retype new password")
            row.configuration[FormRowDescriptor.Configuration.VisualConstraintsClosure] = VisualConstraints.textFieldRow
            return row
        }(),
    ]

    var form: FormDescriptor {
        let form = FormDescriptor()

        let currentPasswordSection = FormSectionDescriptor()
        currentPasswordSection.headerTitle = "Current Password"
        currentPasswordSection.addRow(formRowDescriptors[Tags.currentPassword]!)

        let newPasswordSection = FormSectionDescriptor()
        newPasswordSection.headerTitle = "New Password"
        newPasswordSection.addRow(formRowDescriptors[Tags.newPassword]!)
        newPasswordSection.addRow(formRowDescriptors[Tags.newPasswordVerify]!)
        newPasswordSection.footerTitle = "Your password must be at least 8 characters and include a number, an uppercase letter, and a lowercase letter."

        form.sections = [currentPasswordSection, newPasswordSection]

        return form
    }
}
