//
//  SignUpFormView.swift
//  Doorbell
//
//  Created by Angelo on 6/2/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import KHAForm

public class SignUpFormView {
    // MARK: Constants
    struct Constants {
        static let textLabelWidth = 115
    }

    struct Cells {
        let firstName: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textLabel?.text = "First Name"
            cell.textField.placeholder = "First"
            cell.textField.clearButtonMode = .WhileEditing

            let constraints = cell.contentView.constraints() as! [NSLayoutConstraint]
            constraints.first?.constant = CGFloat(integerLiteral: Constants.textLabelWidth)

            return cell
        }()

        let lastName: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textLabel?.text = "Last Name"
            cell.textField.placeholder = "Last"
            cell.textField.clearButtonMode = .WhileEditing

            let constraints = cell.contentView.constraints() as! [NSLayoutConstraint]
            constraints.first?.constant = CGFloat(integerLiteral: Constants.textLabelWidth)

            return cell
        }()

        let email: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textLabel?.text = "Email"
            cell.textField.placeholder = "name@example.com"
            cell.textField.clearButtonMode = .WhileEditing

            let constraints = cell.contentView.constraints() as! [NSLayoutConstraint]
            constraints.first?.constant = CGFloat(integerLiteral: Constants.textLabelWidth)

            return cell
        }()

        let username: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textLabel?.text = "Username"
            cell.textField.placeholder = "Username"
            cell.textField.clearButtonMode = .WhileEditing

            let constraints = cell.contentView.constraints() as! [NSLayoutConstraint]
            constraints.first?.constant = CGFloat(integerLiteral: Constants.textLabelWidth)

            return cell
        }()

        let password: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textLabel?.text = "Password"
            cell.textField.placeholder = "Password"
            cell.textField.clearButtonMode = .WhileEditing
            cell.textField.secureTextEntry = true

            let constraints = cell.contentView.constraints() as! [NSLayoutConstraint]
            constraints.first?.constant = CGFloat(integerLiteral: Constants.textLabelWidth)

            return cell
        }()

        let passwordVerify: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textLabel?.text = "Verify"
            cell.textField.placeholder = "Retype password"
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
            [cells.firstName, cells.lastName, cells.email],
            [cells.username, cells.password, cells.passwordVerify]
        ]
    }


    // MARK: Instance Methods
    func footerForSection(section: Int) -> String? {
        switch section {
        case 1:
            return "Your password must be at least 8 characters and include a number, an uppercase letter, and a lowercase letter."
        default:
            return nil
        }
    }
}
