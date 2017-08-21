
import Foundation
import XCTest

@testable import Outlook_Ommkar

class EventLocationTests: XCTestCase {
    var location: EventLocation?
    func testNil() {
        // Construct with inacceptable values and check for nil.
        location = EventLocation(description: "", latitude: 12.0, longitude: 22.0)
        XCTAssertNil(location)
        location = EventLocation(description: "Valid description", latitude: -120.0, longitude: 120)
        XCTAssertNil(location)
        location = EventLocation(description: "Valid description", latitude: 45.0, longitude: -22500)
        XCTAssertNil(location)
    }

    func testGetter() {
        // Construct with acceptable values and check for correctness of values
        let description = "Starbucks", latitude = 17.0, longitude = 77.0
        location = EventLocation(description: description, latitude: latitude, longitude: longitude)
        XCTAssertNotNil(location)
        XCTAssertEqual(location!.description, description)
        XCTAssertEqual(location!.latitude, latitude)
        XCTAssertEqual(location!.longitude, longitude)
    }

    func testSetter() {
        // Construct with acceptable values and call all mutating functions and setters and check for correctness of values
    }
}
