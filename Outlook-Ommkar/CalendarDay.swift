
import Foundation

protocol DayComparable: Comparable {
    var day: Int { get }
    var month: Int { get }
    var year: Int { get }
}

struct CalendarDay: DayComparable {
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
}

extension CalendarDay {
    static func == (lhs: CalendarDay, rhs: CalendarDay)-> Bool {
        return (lhs.day == rhs.day) && (lhs.month == rhs.month) && (lhs.year == rhs.year)
    }
    static func < (lhs: CalendarDay, rhs: CalendarDay)-> Bool {
        if (lhs.year < rhs.year) {
            return true
        }
        else if (lhs.month < rhs.month) {
            return true
        }
        else if (lhs.day < rhs.day) {
            return true
        }
        else {
            return false
        }
    }
}

extension CalendarDay {
    mutating func select() {
        selected = true
    }
    mutating func deselect() {
        selected = false
    }
    var isSelected: Bool {
        return selected
    }
    var hasEvent: Bool {
        return events.count > 0
    }
    var displayString: String {
        return "\(weekdayString), \(monthString) \(dayString)"
    }
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
}

extension CalendarDay: CalendarDayInformation {}
