//
//  FormViewController.swift
//  Doorbell
//
//  Created by Angelo on 6/8/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import UIKit
import PKHUD
import Evergreen
import KHAForm
import SwiftValidator

class FormViewController: KHAFormViewController, FormProtocol {
    // MARK: Class Properties


    // MARK: Instance Properties
    var formView: FormViewProtocol?
    let validator = Validator()


    // MARK: Life-Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureCells()
        configureValidator()
    }


    // MARK: KHAFormViewDataSource Protocol Methods
    override func formCellsInForm(form: KHAFormViewController) -> [[KHAFormCell]] {
        return formView!.cellsInSections
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formView!.headerForSection(section)
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return formView!.footerForSection(section)
    }


    // MARK: ValidatorDelegate Protocol Methods
    func validationSuccessful() {
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
    }

    func configureCells() {
    }

    func configureValidator() {
    }

    func submit() {
        validator.validate(self)
    }
}
