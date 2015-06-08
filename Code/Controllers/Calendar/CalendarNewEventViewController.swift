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

class CalendarNewEventViewController: FormViewController {

    // MARK: Class Properties


    // MARK: Instance Properties


    // MARK: Life-Cycle Methods
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)

        self.formView = CalendarNewEventFormView()
    }


    // MARK: FormViewController Methods
    override func configureUI() {
        title = "New Event"

        let addButton = UIBarButtonItem(title: "Add", style: .Done, target: self, action: "submit")
        navigationItem.rightBarButtonItem = addButton

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        navigationItem.leftBarButtonItem = cancelButton
    }

    override func configureValidator() {
        let formView = self.formView as! CalendarNewEventFormView

        validator.registerField(formView.cells.location.textField, rules: [RequiredRule()])
    }

    override func validationSuccessful() {
        let formView = self.formView as! CalendarNewEventFormView

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


    // MARK: Methods
    func cancel() {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
