
import Foundation
import UIKit

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
