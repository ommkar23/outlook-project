
import Foundation
import UIKit

enum EventStatus: ColorRepresentable {
    case past
    case present
    case future

    var color: UIColor {
        switch self {
        case .past:
            return UIColor.red
        case .present:
            return UIColor.green
        case .future:
            return UIColor.orange
        }
    }
}

struct CalendarEvent {
    let title: String
    let startDate: Date
    let endDate: Date
    let organizer: EventPerson
    var attendees: [EventPerson]?
    var location: EventLocation?

    init?(title: String, startDate: Date, endDate: Date, organizer: EventPerson, attendees: [EventPerson]?, location: EventLocation?) {
        // title should not be empty
        guard title.isEmpty != true else { return nil }
        // startDate should be before endDate
        guard startDate < endDate else { return nil }
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.organizer = organizer
        self.attendees = attendees
        self.location = location
    }
    init?(title: String, startDateString: String, endDateString: String, organizer: EventPerson, attendees: [EventPerson]?, location: EventLocation?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
        guard let startDate = dateFormatter.date(from: startDateString) else { return nil }
        guard let endDate = dateFormatter.date(from: endDateString) else { return nil }
        self.init(title: title, startDate: startDate, endDate: endDate, organizer: organizer, attendees: attendees, location: location)
    }

    init?(eventDictionary dictionary: [String: Any]) {
        guard let startDateString = dictionary["startDate"] as? String else { return nil }
        guard let endDateString = dictionary["endDate"] as? String else { return nil }
        guard let title = dictionary["title"] as? String else { return nil }
        guard let organizerDictionary = dictionary["organizer"] as? [String: Any] else { return nil }
        guard let organizer = EventPerson(personDictionary: organizerDictionary) else { return nil }
        var attendees: [EventPerson]?
        if let attendeesArray = dictionary["attendees"] as? [[String: Any]] {
            attendees = attendeesArray.flatMap {
                attendeeDictionary in
                return EventPerson(personDictionary: attendeeDictionary)
            }
        }
        var location: EventLocation?
        if let locationDictionary = dictionary["location"] as? [String: Any] {
            location = EventLocation(locationDictionary: locationDictionary)
        }
        self.init(title: title, startDateString: startDateString, endDateString: endDateString, organizer: organizer, attendees: attendees, location: location)
    }
}

extension CalendarEvent: Comparable {
    static func < (lhs: CalendarEvent, rhs: CalendarEvent)-> Bool {
        return lhs.startDate < rhs.startDate
    }

    static func == (lhs: CalendarEvent, rhs: CalendarEvent)-> Bool {
        return lhs.startDate == rhs.startDate
    }
}

extension CalendarEvent: EventInformation {
    var startTimeString: String {
        var hour = Calendar.current.component(.hour, from: startDate)
        let minute = Calendar.current.component(.minute, from: startDate)
        var hourString: String
        var minuteString: String
        var ampm: String = ""
        if hour >= 12 {
            ampm += "PM"
        }
        else {
            ampm += "AM"
        }
        hour = (hour == 0 || hour == 12) ? hour : hour % 12
        if hour/10 == 0 {
            hourString = "0\(hour)"
        }
        else {
            hourString = "\(hour)"
        }
        if minute/10 == 0 {
            minuteString = "0\(minute)"
        }
        else {
            minuteString = "\(minute)"
        }
        return "\(hourString): \(minuteString) \(ampm)"
    }
    var durationString: String {
        var duration = Int(endDate.timeIntervalSince(startDate))
        let days = duration / (24 * 60 * 60)
        duration = duration % (24 * 60 * 60)
        let hours = Int(duration) / (60 * 60)
        duration = duration % (60 * 60)
        let minutes = duration / (60)
        var string = ""
        if days > 0 {
            string += "\(days)d "
        }
        if hours > 0 {
            string += "\(hours)h "
        }
        if minutes > 0 {
            string += "\(minutes)m"
        }
        return string
    }
    
    var status: ColorRepresentable {
        if endDate < Date() {
            return EventStatus.past
        }
        else if startDate <= Date() {
            return EventStatus.present
        }
        else {
            return EventStatus.future
        }
    }
    var locationInfo: LocationInformation? {
        return location
    }
    var attendeesList: [ContactInformation]? {
        return attendees
    }
}

struct EventLocation: LocationInformation {
    let latitude: Double
    let longitude: Double
    let description: String
    
    init?(description: String, latitude: Double, longitude: Double) {
        guard !description.isEmpty else { return nil }
        guard latitude >= -90.0 && latitude <= 90.0 else { return nil }
        guard longitude >= -180.0 && longitude <= 180.0 else { return nil }
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(locationDictionary dictionary: [String: Any]) {
        if let description = dictionary["description"] as? String,
            let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double {
            self.init(description: description, latitude: latitude, longitude: longitude)
        }
        else {
            return nil
        }
    }
}

struct EventPerson: ContactInformation {
    var email: String?
    var name: String?
    var image: UIImage?
    
    init?(email: String, name: String?, image: UIImage? = nil) {
        guard !email.isEmpty else { return nil }
        self.email = email
        self.name = name
        self.image = image
    }
    
    init?(personDictionary dictionary: [String: Any]) {
        guard let email = dictionary["email"] as? String else { return nil }
        let name = dictionary["name"] as? String
        self.init(email: email, name: name)
    }
}
