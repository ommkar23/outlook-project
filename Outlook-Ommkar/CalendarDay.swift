
import Foundation

enum CalendarCellOption {
    case firstDay
    case selected
    case hasEvent
}

struct CalendarDay {
    let day: Int
    let month: Int
    let year: Int
    let weekday: Int
    var events: [CalendarEvent] = []
    var selected = false
    init(day: Int, month: Int, year: Int, weekday: Int) {
        self.day = day
        self.month = month
        self.year = year
        self.weekday = weekday
    }
    mutating func add(event: CalendarEvent) {
        // Assuming average number of events per day is a relatively low number. Sorting every time an event is added is acceptable.
        events.append(event)
        events.sort()
    }
    mutating func select() {
        selected = true
    }
    mutating func deselect() {
        selected = false
    }
}

extension CalendarDay: CalendarDayInformation {
    var dayString: String {
        if day/10 == 0 {
            return "0\(day)"
        }
        else {
            return "\(day)"
        }
    }
    var weekdayString: String {
        return ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][weekday - 1]
    }
    var monthString: String {
        return ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "Novemeber", "December"][month - 1]
    }
    var shortMonthString: String {
        return monthString.substring(to: monthString.index(monthString.startIndex, offsetBy: 3))
    }
    var titleString: String {
        return "\(monthString), \(year)"
    }
    var displayString: String {
        return "\(weekdayString), \(monthString) \(dayString)"
    }
    var eventCount: Int {
        return events.count
    }
    var hasEvent: Bool {
        return eventCount > 0
    }
    var isSelected: Bool {
        return selected
    }
    var calendarCellOptions: Set<CalendarCellOption> {
        var options: Set<CalendarCellOption> = []
        if isSelected {
            options.insert(.selected)
        }
        if day == 1 {
            options.insert(.firstDay)
        }
        if eventCount > 0 {
            options.insert(.hasEvent)
        }
        return options
    }
    func eventInformation(at index: Int) -> EventInformation {
        return events[index]
    }
}
