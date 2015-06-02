//
//  LogInFormView.swift
//  Doorbell
//
//  Created by Angelo on 6/2/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import SwiftForms

public class LogInFormView {
    // MARK: Class Properties
    struct Tags {
        static let username = "username"
        static let password = "password"
        static let signUp = "signUp"
    }

    private struct RowConfigurationTypes {
        static let DefaultButton = [
            "titleLabel.textAlignment": NSTextAlignment.Left.rawValue,
            "titleLabel.textColor": UIColor(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1.0),
            "accessoryType": UITableViewCellAccessoryType.DisclosureIndicator.rawValue
        ]
    }


    // MARK: Instance Properties
    var formRowDescriptors: [String: FormRowDescriptor] = [
        Tags.username: {
            let row = FormRowDescriptor(tag: Tags.username, rowType: .Name, title: "Username", placeholder: "Username")
            row.title = nil
            return row
        }(),

        Tags.password: {
            let row = FormRowDescriptor(tag: Tags.password, rowType: .Password, title: "Password", placeholder: "Password")
            row.title = nil
            return row
        }(),

        Tags.signUp: {
            let row = FormRowDescriptor(tag: Tags.signUp, rowType: .Button, title: "Create a new Doorbell account")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = RowConfigurationTypes.DefaultButton
            return row
        }()
    ]

    var form: FormDescriptor {
        let form = FormDescriptor()

        let credentialsSection = FormSectionDescriptor()
        credentialsSection.headerTitle = "Account Credentials"
        credentialsSection.addRow(formRowDescriptors[Tags.username]!)
        credentialsSection.addRow(formRowDescriptors[Tags.password]!)

        let signUpSection = FormSectionDescriptor()
        signUpSection.addRow(formRowDescriptors[Tags.signUp]!)
        signUpSection.footerTitle = "Join Doorbell now to start chatting with your clients. The first 3 months are FREE and then only $10 a month."

        form.sections = [credentialsSection, signUpSection]

        return form
    }
}