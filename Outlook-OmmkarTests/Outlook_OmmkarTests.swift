
import XCTest
@testable import Outlook_Ommkar

class Outlook_OmmkarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class TestFileReader {
    func readArrayOfDictionaries(fileName: String, extn: String = "json")-> [[AnyHashable: Any]]? {
        guard let data = readFile(fileName: fileName, extn: extn) else { return nil }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as? [[AnyHashable: Any]]
        }
        catch {
            return nil
        }
    }
    
    func readDictionary(fileName: String, extn: String = "json")-> [AnyHashable: Any]? {
        guard let data = readFile(fileName: fileName) else { return nil }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as? [AnyHashable: Any]
        }
        catch {
            return nil
        }
    }
    
    func readFile(fileName: String, extn: String = "json")-> Data? {
        guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: extn) else { return nil }
        do {
            let data = try Data(contentsOf: fileUrl)
            return data
        }
        catch {
            return nil
        }
    }
}
