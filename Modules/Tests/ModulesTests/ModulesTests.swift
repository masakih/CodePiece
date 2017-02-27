import XCTest
@testable import Modules

class ModulesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Modules().text, "Hello, World!")
    }


    static var allTests : [(String, (ModulesTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
