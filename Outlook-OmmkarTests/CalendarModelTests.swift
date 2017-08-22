
import Foundation
import XCTest

@testable import Outlook_Ommkar

class CalendarModelTests: XCTestCase {
    
    var calendarModel = CalendarModel(daysBeforeToday: 90, daysAfterToday: 360)
    
    func testSelection() {
        XCTAssert(calendarModel.dayCount <= (90+360+1) && calendarModel.dayCount >= (90+360+1-6-6))
    }
    
    func testFromFile() {
        let fileReader = TestFileReader()
        guard let dictionary = fileReader.readDictionary(fileName: "Events") as? [String: Any] else {
            XCTFail("Error reading file")
            return
        }
        guard let eventsArray = dictionary["events"] as? [[String: Any]] else {
            XCTFail("Events array not in dictionary")
            return
        }
        let events = eventsArray.flatMap({
            return CalendarEvent(eventDictionary: $0)
        })
        XCTAssert(events.count > 0) // Checking if able to load event data from file
        calendarModel.addEvents(events)
        let eventCountInModel = (0..<calendarModel.dayCount).flatMap({
            calendarModel.dayInformation(at: $0)
        }).reduce(0, {
            return $0.0 + $0.1.eventCount
        })
        XCTAssertEqual(events.count, eventCountInModel) // Checking if event count in file equals event count in model
        
        _ = calendarModel.selectToday()
        
        if let todayInformation = (0..<calendarModel.dayCount).flatMap({
            calendarModel.dayInformation(at: $0)
        }).first(where: {
            $0.isSelected
        }) {
            // Checking if today is selected correctly
            let todayDay = Calendar.current.component(.day, from: Date())
            XCTAssertEqual(todayInformation.day, todayDay)
            let todayMonth = Calendar.current.component(.month, from: Date())
            XCTAssertEqual(todayInformation.month, todayMonth)
            let todayYear = Calendar.current.component(.year, from: Date())
            XCTAssertEqual(todayInformation.year, todayYear)
        }
        
        //Check if events are sorted in each day
        (0..<calendarModel.dayCount).flatMap({
            calendarModel.dayInformation(at: $0)
        }).forEach({
            dayInfo in
            var reduceResult: (Bool, Date) = (true, Date.distantPast)
            reduceResult = (0..<dayInfo.eventCount).flatMap({
                dayInfo.eventInformation(at: $0)
            }).reduce(reduceResult, {
                if reduceResult.0 {
                    if ($0.1.startDate >= reduceResult.1) {
                        return (true, $0.1.startDate)
                    }
                    else {
                        return (false, $0.1.startDate)
                    }
                }
                else {
                    return reduceResult
                }
            })
            if !reduceResult.0 {
                XCTFail("Events are not sorted")
            }
        })
        
        
    }
    
    
}
