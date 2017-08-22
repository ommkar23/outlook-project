
import Foundation
import UIKit

//MARK: Protocols that models conform to

protocol ColorRepresentable {
    var color: UIColor { get }
}

protocol ContactInformation {
    var image: UIImage? { get }
    var name: String? { get }
    var email: String? { get }
}

protocol ContactList {
    var count: Int { get }
    subscript(index: Int)-> ContactInformation { get }
}

protocol LocationInformation {
    var latitude: Double { get }
    var longitude: Double { get }
    var description: String { get }
}

protocol EventInformation {
    var durationString: String { get }
    var startTimeString: String { get }
    var status: ColorRepresentable { get }
    var title: String { get }
    var locationInfo: LocationInformation? { get }
    var attendeesList: [ContactInformation]? { get }
}

protocol CalendarDayInformation {
    var day: Int { get }
    var hasEvent: Bool { get }
    var month: Int { get }
    var isSelected: Bool { get }
    var shortMonthString: String { get }
}

//MARK: Protocols that views that display model info conform to

protocol EventInformationDisplay {
    func displayEventInformation(eventInfo: EventInformation)
}


protocol EventAttendeesDisplay {
    func displayAttendees(contacts: [ContactInformation])
}

protocol EventStatusDisplay {
    func displayEventStatus(status: ColorRepresentable)
}

protocol EventLocationDisplay {
    func displayEventLocation(location: LocationInformation)
}

protocol HorizontalContactDisplay {
    func displayContactList(contactList: [ContactInformation])
}

protocol ColorDisplayable {
    func displayColor(color: UIColor)
}

protocol EventTimeDescriptionDisplay: AnyObject {
    var durationText: String? { get set }
    var startTimeText: String? { get set }
    var statusColor: UIColor? { get set }
}

protocol EventDescriptionDisplay {
    var titleText: String? { get set }
}

protocol ContactDisplayable {
    func displayContact(contact: ContactInformation)
}
protocol ContactLabelDisplayable: ContactDisplayable {
    func setColor(_ color: UIColor)
}

protocol CalendarDayDisplayable {
    func displayCalendarDay(calendarDay: CalendarDayInformation)
}
