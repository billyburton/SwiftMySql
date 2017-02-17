import XCTest
import SwiftCMySqlMac
@testable import SwiftMySql

class SwiftMySqlReadAdapterTests: XCTestCase {
    
    func test_adapter_fill() {
        if let connection = try? MySqlConnectionMock(server: "", database: "", user: "", password: "") {
            let params = [String: String]()
            
            if let dogs: [Dog] = try? Dog.fill(connection: connection, parameters: params) {
                XCTAssertEqual(connection.query, "SELECT * FROM Dogs")
                XCTAssert(dogs.count == 2, "Not enough dogs")
                XCTAssert(dogs[0].name == "Fido", "Wrong dog name")
                return
            }
        }
        
        XCTAssert(false, "Test failed")
    }
}
