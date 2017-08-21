
import Foundation

enum CalendarCellOptions {
    case firstDay
    case selected
    case hasEvent
}

protocol CalendarModelUpdate: AnyObject {
    func modelIsReady()
    func didSelect(at index: Int)
    func didDeSelect(at index: Int)
}

struct CalendarModel {

    weak var delegate: CalendarModelUpdate?

    var days: [CalendarDay]

    var selectedIndex: Int?
    
    init(daysBeforeToday: Int = 90, daysAfterToday: Int = 360) {
        days = (-daysBeforeToday...daysAfterToday).flatMap({
            Calendar.current.date(byAdding: .day, value: $0, to: Date())
        }).flatMap({
            let day = Calendar.current.component(.day, from: $0)
            let month = Calendar.current.component(.month, from: $0)
            let year = Calendar.current.component(.year, from: $0)
            let weekday = Calendar.current.component(.weekday, from: $0)
            return CalendarDay(day: day, month: month, year: year, weekday: weekday)
        })
        while days.first?.weekday != 1 {
            _ = days.removeFirst()
        }
        while days.last?.weekday != 7 {
            _ = days.removeLast()
        }
    }

    mutating func loadEvents() {
        do {
            if let file_url = Bundle.main.url(forResource: "Events", withExtension: "json") {
                let data = try Data(contentsOf: file_url)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = json as? [String: Any],
                    let events = jsonDict["events"] as? [[String: Any]] {
                    saveEvents(events: events)
                }
            }
        }
        catch (let error) {
            print(error.localizedDescription)
        }
    }

    mutating func saveEvents(events: [[String: Any]]) {
        let calendarEvents: [CalendarEvent] = events.flatMap {
            CalendarEvent(eventDictionary: $0)
        }
        addEvents(calendarEvents)
    }

    mutating func addEvents(_ events: [CalendarEvent]) {
        events.forEach({
            event in
            let eventYear = Calendar.current.component(.year, from: event.startDate)
            let eventMonth = Calendar.current.component(.month, from: event.startDate)
            let eventDay = Calendar.current.component(.day, from: event.startDate)
            if let findIndex = days.index(where: {
                day in
                return day.day == eventDay && day.month == eventMonth && day.year == eventYear
            }) {
                days[findIndex].events.append(event)
            }
        })
        delegate?.modelIsReady()
    }

    var dayCount: Int {
        return days.count
    }

    func displayString(forSection at: Int)-> String {
        return days[at].displayString
    }

    func dateString(forSection at: Int)-> String {
        return days[at].dayString
    }

    func selected(forItem at: Int)-> Bool {
        return days[at].isSelected
    }
    
    mutating func selectToday()-> Int? {
        let todayDay = Calendar.current.component(.day, from: Date())
        let todayMonth = Calendar.current.component(.month, from: Date())
        let todayYear = Calendar.current.component(.year, from: Date())
        if let todayIndex = days.index(where: {
            return $0.day == todayDay && $0.month == todayMonth && $0.year == todayYear
        })
        {
            select(at: todayIndex)
            return todayIndex
        }
        return nil
    }

    mutating func select(at index: Int) {
        if let selectedIndex = selectedIndex {
            days[selectedIndex].deselect()
            delegate?.didDeSelect(at: selectedIndex)
        }
        days[index].select()
        selectedIndex = index
        delegate?.didSelect(at: index)
    }

    func calendarCellOptions(forSection at: Int)-> Set<CalendarCellOptions> {
        var options: Set<CalendarCellOptions> = []
        let day = days[at]
        if day.isSelected {
            options.insert(.selected)
        }
        if day.day == 1 {
            options.insert(.firstDay)
        }
        if day.events.count > 0 {
            options.insert(.hasEvent)
        }
        return options
    }
    
    func getTitleForIndex(at index: Int)-> String {
        let day = days[index]
        return day.titleString
    }
}

extension Date {
    var weekDay: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var dateValue: Int {
        return Calendar.current.component(.day, from: self)
    }
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    var shortDayString: String {
        return dayString.substring(to: dayString.index(dayString.startIndex, offsetBy: 3))
    }
    var dayString: String {
        return ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][weekDay - 1]
    }
    var shortMonthString: String {
        return monthString.substring(to: monthString.index(monthString.startIndex, offsetBy: 3))
    }

    var monthString: String {
        return ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "Novemeber", "December"][month - 1]
    }
}
