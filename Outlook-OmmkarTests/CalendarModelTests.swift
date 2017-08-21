
import Foundation
import XCTest

@testable import Outlook_Ommkar

class CalendarModelTests: XCTestCase {
    
    var calendarModel = CalendarModel()
    
    func testSelection() {
        calendarModel.select(at: 10)
        XCTAssertNotNil(calendarModel.selectedIndex)
        XCTAssertEqual(calendarModel.selectedIndex!, 10)
        let todayIndex = calendarModel.selectToday()
        XCTAssertNotNil(todayIndex)
        XCTAssertEqual(calendarModel.displayString(forSection: todayIndex!), "Monday, August 21")
        XCTAssertEqual(calendarModel.getTitleForIndex(at: todayIndex!), "August, 2017")
    }
}
