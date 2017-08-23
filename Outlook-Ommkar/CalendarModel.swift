
import Foundation

protocol CalendarModelUpdate: AnyObject {
    func modelIsReady()
    func didSelect(at index: Int)
    func didDeSelect(at index: Int)
    func didUpdateEvent(at indexPath: IndexPath)
    func fetchWeatherIcon(at indexPath: IndexPath, for location: LocationInformation, timestamp: Double)
}

struct CalendarModel {

    weak var delegate: CalendarModelUpdate?

    fileprivate var days: [CalendarDay]

    fileprivate var selectedIndex: Int?
    
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
        //Removing days till range starts from a Sunday
        while days.first?.weekday != 1 {
            _ = days.removeFirst()
        }
        //Removing days till range ends on a Saturday
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
            if let findIndex = searchDayIndex(for: event, in: days, range: 0 ..< days.count) {
                days[findIndex].add(event: event)
            }
        })
        delegate?.modelIsReady()
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
            //fetchWeatherInfo(for: 14, from: todayIndex)
            return todayIndex
        }
        return nil
    }
    
    func fetchWeatherInfo(for numberOfDays: Int, from dayIndex: Int) {
        (dayIndex...dayIndex+numberOfDays).forEach({
            section in
            days[section].events.enumerated().forEach({
                (row, event) in
                guard let location = event.locationInfo else { return }
                let startTimeStamp = event.startDate.timeIntervalSince1970
                delegate?.fetchWeatherIcon(at: IndexPath(row: row, section: section), for: location, timestamp: startTimeStamp)
            })
        })
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
    
    mutating func addWeatherIconForEvent(at indexPath: IndexPath, icon: String) {
        days[indexPath.section].addWeatherIconForEvent(at: indexPath.row, icon: icon)
        delegate?.didUpdateEvent(at: indexPath)
    }
    
}

extension CalendarModel {
    //MARK: Binary search for inserting events over days array.
    func searchDayIndex(for event: CalendarEvent, in days: [CalendarDay], range: Range<Int>)-> Int? {
        if range.lowerBound >= range.upperBound { return nil }
        else {
            let mid = range.lowerBound + (range.upperBound - range.lowerBound) / 2
            if compare(event: event, day: days[mid]) == -1 {
                return searchDayIndex(for: event, in: days, range: range.lowerBound ..< mid)
            }
            else if compare(event: event, day: days[mid]) == 1 {
                return searchDayIndex(for: event, in: days, range: mid+1 ..< range.upperBound)
            }
            else {
                return mid
            }
        }
    }
    func compare(event: CalendarEvent, day: CalendarDay)-> Int {
        let eventDay = Calendar.current.component(.day, from: event.startDate)
        let eventMonth = Calendar.current.component(.month, from: event.startDate)
        let eventYear = Calendar.current.component(.year, from: event.startDate)
        if day.year < eventYear { return 1 }
        if day.year > eventYear { return -1 }
        if day.month < eventMonth { return 1 }
        if day.month > eventMonth { return -1 }
        if day.day < eventDay { return 1 }
        if day.day > eventDay { return -1 }
        return 0
    }
}

extension CalendarModel: CalendarInformation {
    var dayCount: Int {
        return days.count
    }
    
    func dayInformation(at index: Int) -> CalendarDayInformation {
        return days[index]
    }
}
