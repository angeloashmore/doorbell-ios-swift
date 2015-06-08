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
    let formView = CalendarNewEventFormView()
    let validator = Validator()


    // MARK: Life-Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureValidator()
    }


    // MARK: KHAFormViewDataSource Protocol Methods
    override func formCellsInForm(form: KHAFormViewController) -> [[KHAFormCell]] {
        return formView.cellsInSections
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formView.titleForSection(section)
    }


    // MARK: ValidatorDelegate Protocol Methods
    func validationSuccessful() {
        let event = Event()

        event["location"] = formView.cells.location.textField.text
        event["description"] = formView.cells.description.textView.text
        event["startDate"] = formView.cells.startTime.date
        event["endDate"] = formView.cells.endTime.date
        event["notes"] = formView.cells.description.textView.text

        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        event.promiseSave()
            .then { _ -> Void in
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
                self.cancel()

            }.catch { error -> Void in
                PKHUD.sharedHUD.hide()

                var message: String

                switch error.code {
                default:
                    message = "An error occured. Please re-check all fields and try again."
                }

                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)

                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(OKAction)

                self.presentViewController(alertController, animated: true, completion: nil)

            }
    }

    func validationFailed(errors: [UITextField : ValidationError]) {
        log(errors, forLevel: .Error)

        let alertController = UIAlertController(title: "Error", message: "Please re-check all fields and try again", preferredStyle: .Alert)

        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }


    // MARK: Methods
    func configureUI() {
        let addButton = UIBarButtonItem(title: "Add", style: .Done, target: self, action: "submit")
        navigationItem.rightBarButtonItem = addButton

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        navigationItem.leftBarButtonItem = cancelButton
    }

    func configureValidator() {
        validator.registerField(formView.cells.location.textField, rules: [RequiredRule()])
    }

    func submit() {
        validator.validate(self)
    }

    func cancel() {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
