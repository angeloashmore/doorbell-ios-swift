//
//  CalendarNewEventViewController.swift
//  Doorbell
//
//  Created by Angelo on 6/7/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import PKHUD
import Evergreen
import KHAForm
import SwiftValidator

class CalendarNewEventViewController: KHAFormViewController, KHAFormViewDataSource, ValidationDelegate {

    // MARK: Class Properties


    // MARK: Instance Properties
    let validator = Validator()


    // MARK: Life-Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureValidator()
    }


    // MARK: KHAFormViewDataSource Protocol Methods
    override func formCellsInForm(form: KHAFormViewController) -> [[KHAFormCell]] {
        return CalendarNewEventFormView.cellsInSections
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CalendarNewEventFormView.titleForSection(section)
    }


    // MARK: ValidatorDelegate Protocol Methods
    func validationSuccessful() {
        // Validation successful
        let event = Event()

        event["location"] = CalendarNewEventFormView.Cells.location.textField.text
        event["description"] = CalendarNewEventFormView.Cells.description.textView.text
        event["startDate"] = CalendarNewEventFormView.Cells.startTime.date
        event["endDate"] = CalendarNewEventFormView.Cells.endTime.date
        event["notes"] = CalendarNewEventFormView.Cells.description.textView.text

        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        event.promiseSave()
            .then { object -> Void in
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
                self.cancel()

            }.catch { error -> Void in
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Error", image: PKHUDAssets.crossImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
                log(error, forLevel: .Error)

            }
    }

    func validationFailed(errors: [UITextField : ValidationError]) {
        // Validation unsuccessful
        log(errors, forLevel: .Error)
    }


    // MARK: Methods
    func configureUI() {
        let addButton = UIBarButtonItem(title: "Add", style: .Done, target: self, action: "submit")
        navigationItem.rightBarButtonItem = addButton

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        navigationItem.leftBarButtonItem = cancelButton
    }

    func configureValidator() {
        validator.registerField(CalendarNewEventFormView.Cells.location.textField, rules: [RequiredRule()])
    }

    func submit() {
        validator.validate(self)
    }

    func cancel() {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
