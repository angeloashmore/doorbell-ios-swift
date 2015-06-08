//
//  LogInFormView.swift
//  Doorbell
//
//  Created by Angelo on 6/2/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import KHAForm

public class LogInFormView {
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
            cell.button.setTitle("Create a new Doorbell account", forState: .Normal)
            cell.button.setTitleColor(UIColor(red: 0.0, green: 122.0/255, blue: 1.0, alpha: 1.0), forState: .Normal)
            cell.button.titleLabel?.font = UIFont.systemFontOfSize(17)
            cell.button.contentHorizontalAlignment = .Left
            cell.button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)
            cell.accessoryType = .DisclosureIndicator
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