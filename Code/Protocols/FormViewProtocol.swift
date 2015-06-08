//
//  FormViewProtocol.swift
//  Doorbell
//
//  Created by Angelo on 6/8/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import KHAForm

protocol FormViewProtocol {
    var cellsInSections: [[KHAFormCell]] { get }

    func headerForSection(section: Int) -> String?
    func footerForSection(section: Int) -> String?
}
