//
//  CalendarAddViewController.swift
//  Doorbell
//
//  Created by Angelo on 6/7/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import SwiftForms

class CalendarAddFormView {
    // MARK: Class Properties
    struct Tags {
        static let location = "location"
        static let description = "description"
        static let date = "date"
        static let startTime = "startTime"
        static let endTime = "endTime"
        static let attendees = "attendees"
        static let notes = "notes"
    }

    private struct VisualConstraints {
        static let textFieldRow: VisualConstraintsClosure = { row in
            return ["H:|-16-[titleLabel(90)]-[textField]-16-|"]
        }
    }


    // MARK: Instance Properties
    var formRowDescriptors: [String: FormRowDescriptor] = [
        Tags.location: {
            let row = FormRowDescriptor(tag: Tags.location, rowType: FormRowType.Name, title: "Location", placeholder: "Location")
            row.title = nil
            return row
        }(),

        Tags.description: {
            let row = FormRowDescriptor(tag: Tags.description, rowType: FormRowType.MultilineText, title: "Description", placeholder: "Description")
            row.title = nil
            return row
        }(),

        Tags.date: {
            let row = FormRowDescriptor(tag: Tags.date, rowType: FormRowType.Date, title: "Date")
            return row
        }(),

        Tags.startTime: {
            let row = FormRowDescriptor(tag: Tags.startTime, rowType: FormRowType.Time, title: "Starts")
            return row
        }(),

        Tags.endTime: {
            let row = FormRowDescriptor(tag: Tags.endTime, rowType: FormRowType.Time, title: "Ends")
            return row
        }(),

        Tags.attendees: {
            let row = FormRowDescriptor(tag: Tags.attendees, rowType: FormRowType.Name, title: "Attendees")
            return row
        }(),

        Tags.notes: {
            let row = FormRowDescriptor(tag: Tags.notes, rowType: FormRowType.MultilineText, title: "Notes", placeholder: "Notes")
            row.title = nil
            return row
        }()
    ]

    var form: FormDescriptor {
        let form = FormDescriptor()

        let section1 = FormSectionDescriptor()
        section1.addRow(formRowDescriptors[Tags.location]!)
        section1.addRow(formRowDescriptors[Tags.description]!)

        let section2 = FormSectionDescriptor()
        section2.addRow(formRowDescriptors[Tags.date]!)
        section2.addRow(formRowDescriptors[Tags.startTime]!)
        section2.addRow(formRowDescriptors[Tags.endTime]!)

        let section3 = FormSectionDescriptor()
        section3.headerTitle = "Attendees"
        section3.addRow(formRowDescriptors[Tags.attendees]!)

        let section4 = FormSectionDescriptor()
        section4.addRow(formRowDescriptors[Tags.notes]!)

        form.sections = [section1, section2, section3, section4]

        return form
    }
}
