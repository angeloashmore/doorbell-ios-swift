//
//  SettingsEditProfileFormView.swift
//  Doorbell
//
//  Created by Angelo on 6/2/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import KHAForm

public class SettingsEditProfileFormView: FormViewProtocol {
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

        let professionTitle: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.Selection)
            cell.textLabel?.text = "Professional Title"

            let selectionFormViewController = KHASelectionFormViewController()
            selectionFormViewController.title = "Professional Title"
            selectionFormViewController.selections = ["None", "Real Estate Agent", "Property Manager", "Mortgage Broker", "Other"]
            cell.selectionFormViewController = selectionFormViewController

            return cell
        }()

        let professionLocation: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.Selection)
            cell.textLabel?.text = "Location"

            let selectionFormViewController = KHASelectionFormViewController()
            selectionFormViewController.title = "Location"
            selectionFormViewController.selections = ["Honolulu, Hawaii"]
            cell.selectionFormViewController = selectionFormViewController

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
            [cells.professionTitle, cells.professionLocation]
        ]
    }


    // MARK: Instance Methods
    func headerForSection(section: Int) -> String? {
        switch section {
        case 0:
            return "Personal Info"
        case 1:
            return "Profession"
        default:
            return nil
        }
    }

    func footerForSection(section: Int) -> String? {
        switch section {
        case 0:
            return "Use an email address you are comfortable sharing with others.\n\nYour email address will need to be re-verified if changed."
        case 1:
            return "Users find others using professional titles and geographical location. Select the most accurate option."
        default:
            return nil
        }
    }
}