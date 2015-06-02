//
//  SettingsForm.swift
//  Doorbell
//
//  Created by Angelo on 6/1/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import SwiftForms

public class SettingsFormView {
    // MARK: Class Properties
    struct Tags {
        static let editProfile = "editProfile"
        static let changePassword = "changePassword"
        static let privateAccount = "privateAccount"
        static let aboutThisVersion = "aboutThisVersion"
        static let logOut = "logOut"
    }

    private struct RowConfigurationTypes {
        static let DisclosureIndicatorButton = [
            "titleLabel.textAlignment": NSTextAlignment.Left.rawValue,
            "accessoryType": UITableViewCellAccessoryType.DisclosureIndicator.rawValue
        ]
        static let DefaultButton = [
            "titleLabel.textAlignment": NSTextAlignment.Left.rawValue,
            "titleLabel.textColor": UIColor(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1.0),
        ]
    }

    struct FormRowDescriptors {
        var editProfile: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: Tags.editProfile, rowType: .Button, title: "Edit Profile")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = RowConfigurationTypes.DisclosureIndicatorButton
            return row
        }()

        var changePassword: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: Tags.changePassword, rowType: .Button, title: "Change Password")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = RowConfigurationTypes.DisclosureIndicatorButton
            return row
        }()

        var privateAccount: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: Tags.privateAccount, rowType: .BooleanSwitch, title: "Private Account")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = RowConfigurationTypes.DisclosureIndicatorButton
            return row
        }()

        var aboutThisVersion: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: Tags.aboutThisVersion, rowType: .Button, title: "About This Version")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = RowConfigurationTypes.DisclosureIndicatorButton
            return row
        }()

        var logOut: FormRowDescriptor = {
            let row = FormRowDescriptor(tag: Tags.logOut, rowType: .Button, title: "Log Out")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = RowConfigurationTypes.DefaultButton
            return row
        }()
    }


    // MARK: Instance Properties
    var formRowDescriptors = FormRowDescriptors()

    var form: FormDescriptor {
        let form = FormDescriptor()

        let userSection = FormSectionDescriptor()
        userSection.footerTitle = "When your account is private, only people you approve can see your profile and interact with you."
        userSection.addRow(formRowDescriptors.editProfile)
        userSection.addRow(formRowDescriptors.changePassword)
        userSection.addRow(formRowDescriptors.privateAccount)

        let aboutSection = FormSectionDescriptor()
        aboutSection.addRow(formRowDescriptors.aboutThisVersion)

        let logOutSection = FormSectionDescriptor()
        logOutSection.addRow(formRowDescriptors.logOut)

        form.sections = [userSection, aboutSection, logOutSection]

        return form
    }


    // MARK: Methods
}
