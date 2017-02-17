import XCTest
import SwiftCMySqlMac
@testable import SwiftMySql

class SwiftMySqlCreateAdapterTests: XCTestCase {
    
    func test_adapter_create() {
        let expectedQuery = "INSERT INTO Dogs VALUES ('Fido', '2')"
        
        if let connection = try? MySqlConnectionMock(server: "", database: "", user: "", password: "") {
            let dog = Dog()
            dog.name = "Fido"
            dog.age = 2
            
            try? dog.create(connection: connection)
            
            XCTAssertEqual(connection.query, expectedQuery)
            return
        }
        
        XCTAssert(false, "Test failed")
    }
}
