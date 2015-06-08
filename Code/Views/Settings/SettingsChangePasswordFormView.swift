//
//  SettingsChangePasswordFormView.swift
//  Doorbell
//
//  Created by Angelo on 6/2/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import KHAForm

public class SettingsChangePasswordFormView {
    // MARK: Constants
    struct Constants {
        static let textLabelWidth = 105
    }

    struct Cells {
        let password: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textLabel?.text = "Password"
            cell.textField.placeholder = "New password"
            cell.textField.clearButtonMode = .WhileEditing
            cell.textField.secureTextEntry = true

            let constraints = cell.contentView.constraints() as! [NSLayoutConstraint]
            constraints.first?.constant = CGFloat(integerLiteral: Constants.textLabelWidth)

            return cell
        }()

        let passwordVerify: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textLabel?.text = "Verify"
            cell.textField.placeholder = "Retype new password"
            cell.textField.clearButtonMode = .WhileEditing
            cell.textField.secureTextEntry = true

            let constraints = cell.contentView.constraints() as! [NSLayoutConstraint]
            constraints.first?.constant = CGFloat(integerLiteral: Constants.textLabelWidth)

            return cell
        }()
    }


    // MARK: Class Properties


    // MARK: Class Methods


    // MARK: Instance Properties
    let cells = Cells()

    var cellsInSections: [[KHAFormCell]] {
        return [
            [cells.password, cells.passwordVerify],
            []
        ]
    }


    // MARK: Instance Methods
    func footerForSection(section: Int) -> String? {
        switch section {
        case 0:
            return "Your password must be at least 8 characters and include a number, an uppercase letter, and a lowercase letter."
        case 1:
            return "Note: You will be logged out after changing your password."
        default:
            return nil
        }
    }
}
