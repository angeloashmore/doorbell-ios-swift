//
//  FormProtocol.swift
//  Doorbell
//
//  Created by Angelo on 6/8/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import KHAForm
import SwiftValidator

protocol FormProtocol: KHAFormViewDataSource, ValidationDelegate {
    var validator: Validator { get }

    func configureUI()
    func configureCells()
    func configureValidator()

    func submit()
}
