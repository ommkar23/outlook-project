
import Foundation
import XCTest

@testable import Outlook_Ommkar

class EventPersonTests: XCTestCase {
    var person: EventPerson?
    
    func testNil() {
        person = EventPerson(email: "", name: nil)
        XCTAssertNil(person)
        person = EventPerson(email: "", name: "Dave")
        XCTAssertNil(person)
    }
    
    func testGetter() {
        let email = "ommkarpattnaik@gmail.com", name = "Ommkar Pattnaik"
        person = EventPerson(email: email, name: nil)
        XCTAssertNotNil(person)
        XCTAssertEqual(person!.email, email)
        XCTAssertNil(person!.name)
        person = EventPerson(email: email, name: name)
        XCTAssertNotNil(person)
        XCTAssertEqual(person!.email, email)
        XCTAssertEqual(person!.name, name)
    }
    
    func testFromFile() {
        let fileReader = TestFileReader()
        let persons = fileReader.readArrayOfDictionaries(fileName: "EventPersons") as? [[String: Any]]
        persons?.forEach({
            let person = EventPerson(personDictionary: $0)
            XCTAssertNotNil(person)
        })
    }
}
