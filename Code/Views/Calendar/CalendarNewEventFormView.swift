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
    // MARK: Constants
    struct Constants {
        static let textLabelWidth = 90
    }

    struct Cells {
        let location: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textField.placeholder = "Location"
            cell.textField.clearButtonMode = .WhileEditing
            return cell
        }()

        let description: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextView)
            cell.textView.placeholder = "Description"
            return cell
        }()

        let date: KHAFormCell = {
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

        let startTime: KHAFormCell = {
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

        let endTime: KHAFormCell = {
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

        let attendees: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextField)
            cell.textField.placeholder = "Attendees"
            cell.textField.clearButtonMode = .WhileEditing
            return cell
        }()

        let notes: KHAFormCell = {
            let cell = KHAFormCell.formCellWithType(.TextView)
            cell.textView.placeholder = "Notes"
            return cell
        }()
    }


    // MARK: Class Properties


    // MARK: Class Methods


    // MARK: Instance Properties
    let cells = Cells()

    var cellsInSections: [[KHAFormCell]] {
        return [
            [cells.location, cells.description],
            [cells.date, cells.startTime, cells.endTime],
            [cells.attendees],
            [cells.notes]
        ]
    }


    // MARK: Instance Methods
    func titleForSection(section: Int) -> String? {
        switch section {
        case 2:
            return "Attendees"
        default:
            return nil
        }
    }
}
