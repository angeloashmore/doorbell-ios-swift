//
//  LogInFormView.swift
//  Doorbell
//
//  Created by Angelo on 6/2/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import KHAForm

public class LogInFormView: FormViewProtocol {
    // MARK: Constants
    struct Cells {
        let username: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textField.placeholder = "Username"
            cell.textField.clearButtonMode = .WhileEditing
            return cell
        }()

        let password: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textField.placeholder = "Password"
            cell.textField.clearButtonMode = .WhileEditing
            cell.textField.secureTextEntry = true
            return cell
        }()

        let signUp: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.Button)
            cell.addStyle(.ButtonActionDisclosure)
            cell.button.setTitle("Create a new Doorbell account", forState: .Normal)
            return cell
        }()
    }


    // MARK: Class Properties


    // MARK: Class Methods


    // MARK: Instance Properties
    let cells = Cells()

    var cellsInSections: [[KHAFormCell]] {
        return [
            [cells.username, cells.password],
            [cells.signUp]
        ]
    }


    // MARK: Instance Methods
    func headerForSection(section: Int) -> String? {
        switch section {
        case 0:
            return "Account Credentials"
        default:
            return nil
        }
    }

    func footerForSection(section: Int) -> String? {
        switch section {
        case 1:
            return "Join Doorbell now to start chatting with your clients. The first 3 months are FREE and then only $1 a month."
        default:
            return nil
        }
    }
}