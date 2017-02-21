import XCTest
import SwiftCMySqlMac
@testable import SwiftMySql

class SwiftMySqlUpdateAdapterTests: XCTestCase {
    
    func test_adapter_update() {
        let expectedQuery = "UPDATE Dogs SET Age = '2' WHERE Name = 'Fido'"
        
        if let connection = try? MySqlConnectionMock(server: "", database: "", user: "", password: "") {
            let dog = Dog(name: "Fido", age: 2)
            try? dog.update(connection: connection)
            
            XCTAssertEqual(connection.query, expectedQuery)
            return
        }
        
        XCTAssert(false, "Test failed")
    }
}
