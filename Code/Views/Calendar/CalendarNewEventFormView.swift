//
//  CalendarAddViewController.swift
//  Doorbell
//
//  Created by Angelo on 6/7/15.
//  Copyright (c) 2015 Doorbell. All rights reserved.
//

import Foundation
import KHAForm

class CalendarNewEventFormView {
    // MARK: Class Properties
    struct Cells {
        static let location: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textField.placeholder = "Location"
            cell.textField.clearButtonMode = .Always
            return cell
        }()

        static let description: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextView)
            cell.textView.placeholder = "Description"
            return cell
        }()

        static let date: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.Date)
            cell.textLabel?.text = "Date"
            cell.date = NSDate()
            cell.datePickerMode = .Date
            cell.dateFormatter = {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .LongStyle
                dateFormatter.timeStyle = .NoStyle
                return dateFormatter
            }()
            return cell
        }()

        static let startTime: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.Date)
            cell.textLabel?.text = "Start Time"
            cell.date = NSDate()
            cell.datePickerMode = .Time
            cell.dateFormatter = {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .NoStyle
                dateFormatter.timeStyle = .ShortStyle
                return dateFormatter
            }()
            return cell
        }()

        static let endTime: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.Date)
            cell.textLabel?.text = "End Time"
            cell.date = NSDate()
            cell.datePickerMode = .Time
            cell.dateFormatter = {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .NoStyle
                dateFormatter.timeStyle = .ShortStyle
                return dateFormatter
            }()
            return cell
        }()

        static let attendees: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textField.placeholder = "Attendees"
            cell.textField.clearButtonMode = .Always

            let constraints = cell.contentView.constraints() as! [NSLayoutConstraint]
            constraints.first?.constant = 90

            return cell
        }()

        static let notes: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextView)
            cell.textView.placeholder = "Notes"
            return cell
        }()
    }

    static let cellsInSections = [
        [Cells.location, Cells.description],
        [Cells.date, Cells.startTime, Cells.endTime],
        [Cells.attendees],
        [Cells.notes]
    ]


    // MARK: Class Methods
    static func titleForSection(section: Int) -> String? {
        switch section {
        case 2:
            return "Attendees"
        default:
            return nil
        }
    }


    // MARK: Instance Properties


    // MARK: Instance Methods
}
