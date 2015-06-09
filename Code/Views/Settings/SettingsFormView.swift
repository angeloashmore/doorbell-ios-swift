//
//  SettingsForm.swift
//  Doorbell
//
//  Created by Angelo on 6/1/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import KHAForm

public class SettingsFormView: FormViewProtocol {
    // MARK: Constants
    struct Cells {
        let editProfile: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.Button)
            cell.addStyle(.ButtonDisclosure)
            cell.button.setTitle("Edit Profile", forState: .Normal)
            return cell
        }()

        let changePassword: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.Button)
            cell.addStyle(.ButtonDisclosure)
            cell.button.setTitle("Change Password", forState: .Normal)
            return cell
        }()

        let privateAccount: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.Switch)
            cell.textLabel?.text = "Private Account"
            return cell
        }()

        let aboutThisVersion: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.Button)
            cell.addStyle(.ButtonDisclosure)
            cell.button.setTitle("About This Version", forState: .Normal)
            return cell
        }()

        let logOut: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.Button)
            cell.addStyle(.ButtonAction)
            cell.button.setTitle("Log Out", forState: .Normal)
            return cell
        }()
    }


    // MARK: Class Properties


    // MARK: Class Methods


    // MARK: Instance Properties
    let cells = Cells()

    var cellsInSections: [[KHAFormCell]] {
        return [
            [cells.editProfile, cells.changePassword, cells.privateAccount],
            [cells.aboutThisVersion],
            [cells.logOut]
        ]
    }


    // MARK: Instance Methods
    func headerForSection(section: Int) -> String? {
        return nil
    }

    func footerForSection(section: Int) -> String? {
        switch section {
        case 0:
            return "When your account is private, only people you approve can see your profile and interact with you."
        default:
            return nil
        }
    }
}
