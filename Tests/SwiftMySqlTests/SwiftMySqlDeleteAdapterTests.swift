import XCTest
import SwiftCMySqlMac
@testable import SwiftMySql

class SwiftMySqlDeleteAdapterTests: XCTestCase {
    
    func test_adapter_delete() {
        let expectedQuery = "DELETE FROM Dogs WHERE Name = 'Fido'"
        
        if let connection = try? MySqlConnectionMock(server: "", database: "", user: "", password: "") {
            
            let dog = Dog()
            dog.name = "Fido"
            dog.age = 2
            
            try? dog.delete(connection: connection)
            
            XCTAssertEqual(connection.query, expectedQuery)
            return
        }
        
        XCTAssert(false, "Test failed")
    }
}
