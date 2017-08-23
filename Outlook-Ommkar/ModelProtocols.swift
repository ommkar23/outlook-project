//
//  ModelProtocols.swift
//  Outlook-Ommkar
//
//  Created by Ommkar Pattnaik on 23/08/2017.
//  Copyright © 2017 Ommkar Pattnaik. All rights reserved.
//

import Foundation
import UIKit

//MARK: Protocols that models conform to

protocol CalendarInformation {
    //Information regarding calendar
    var dayCount: Int { get }
    func dayInformation(at index: Int)-> CalendarDayInformation
}

protocol CalendarDayInformation {
    //Information regarding a particular day
    var day: Int { get }
    var month: Int { get }
    var year: Int { get }
    var hasEvent: Bool { get }
    var eventCount: Int { get }
    var isSelected: Bool { get }
    var shortMonthString: String { get }
    var displayString: String { get }
    var titleString: String { get }
    var calendarCellOptions: Set<CalendarCellOption> { get }
    func eventInformation(at index: Int)-> EventInformation
}

protocol EventInformation {
    //Information regarding an event in a day
    var startDate: Date { get }
    var durationString: String { get }
    var startTimeString: String { get }
    var status: ColorRepresentable { get }
    var title: String { get }
    var locationInfo: LocationInformation? { get }
    var attendeesList: [ContactInformation]? { get }
    var weatherIcon: String? { get }
}

protocol LocationInformation {
    var latitude: Double { get }
    var longitude: Double { get }
    var description: String { get }
}

protocol ColorRepresentable {
    var color: UIColor { get }
}

protocol ContactInformation {
    var image: UIImage? { get }
    var name: String? { get }
    var email: String? { get }
}
