import XCTest
@testable import SwiftMySql

class SwiftMySqlTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(SwiftMySql().text, "Hello, World!")
    }


    static var allTests : [(String, (SwiftMySqlTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
