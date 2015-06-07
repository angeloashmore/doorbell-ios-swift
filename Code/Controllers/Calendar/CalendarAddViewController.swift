//
//  CalendarAddViewController.swift
//  Doorbell
//
//  Created by Angelo on 6/7/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import Parse
import PKHUD
import SwiftForms
import SwiftFormsHonour
import Honour

class CalendarAddViewController: FormViewController {

    // MARK: Class Properties


    // MARK: Life-Cycle Methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.loadForm()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "New Event"

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelButton

        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "submit")
        self.navigationItem.rightBarButtonItem = saveButton
    }


    // MARK: Methods
    private func loadForm() {
        let formView = CalendarAddFormView()

        formView.formRowDescriptors[CalendarAddFormView.Tags.location]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty())
        } as ValidatorClosure

        formView.formRowDescriptors[CalendarAddFormView.Tags.description]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty())
        } as ValidatorClosure

        formView.formRowDescriptors[CalendarAddFormView.Tags.date]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty())
        } as ValidatorClosure

        formView.formRowDescriptors[CalendarAddFormView.Tags.startTime]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty())
        } as ValidatorClosure

        formView.formRowDescriptors[CalendarAddFormView.Tags.endTime]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty())
        } as ValidatorClosure

        formView.formRowDescriptors[CalendarAddFormView.Tags.attendees]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty())
        } as ValidatorClosure

        formView.formRowDescriptors[CalendarAddFormView.Tags.notes]!.configuration[FormRowDescriptor.Configuration.ValidatorClosure] = { Void -> Validator in
            return Validator().addRule(NotEmpty())
        } as ValidatorClosure

        self.form = formView.form
    }

    func submit() {
        self.view.endEditing(true)

        if form.validateFormWithHonour() {
            updateUser()
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please re-check all fields and try again", preferredStyle: .Alert)

            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)

            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    func updateUser() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        
        let formValues = form.formValues()
        let firstName = formValues[SettingsEditProfileFormView.Tags.firstName] as? String ?? ""
        let lastName = formValues[SettingsEditProfileFormView.Tags.lastName] as? String ?? ""
        let email = formValues[SettingsEditProfileFormView.Tags.email] as? String ?? ""
        
        let user = PFUser.currentUser()!
        user.setValue(firstName, forKey: "firstName")
        user.setValue(lastName, forKey: "lastName")
        user.setValue(email, forKey: "email")

        user.promiseSave()
            .then { user -> Void in
                PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Success", image: PKHUDAssets.checkmarkImage)
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
                self.cancel()
                
            }.catch(policy: .AllErrors) { (error) -> Void in
                PKHUD.sharedHUD.hide()

                var message: String

                switch error.code {
                case 203:
                    message = "Email taken. Please try another email."
                default:
                    message = "An error occured. Please re-check all fields and try again."
                }

                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)

                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(OKAction)

                self.presentViewController(alertController, animated: true, completion: nil)
            }
    }

    func cancel() {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
