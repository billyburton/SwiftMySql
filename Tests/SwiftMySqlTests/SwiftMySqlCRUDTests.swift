import XCTest
import SwiftCMySqlMac
@testable import SwiftMySql

class SwiftMySqlCRUDTests: XCTestCase {
    let expected_create_command = "INSERT INTO Cats VALUES ('Fifi')"
    let expected_update_command = "UPDATE Cats Set Name = 'Fifi' WHERE Name = 'Fifi'"
    let expected_delete_command = "DELETE FROM Cats WHERE Name = 'Fifi'"
    
    var connection: MySqlConnectionMock?

    override func setUp() {
        connection = try? MySqlConnectionMock(server: "", database: "", user: "", password: "")
    }
    
    func test_CRUD_create() {
        if let connection = connection {
            let cat = Cat()
            cat.name = "Fifi"
            
            try? cat.create(connection: connection)
            
            XCTAssertEqual(expected_create_command, connection.query)
            return
        }
        
        XCTAssert(false)
    }
    
    func test_CRUD_update() {
        if let connection = connection {
            let cat = Cat()
            cat.name = "Fifi"
            
            try? cat.update(connection: connection)
            
            XCTAssertEqual(expected_update_command, connection.query)
            return
        }
        
        XCTAssert(false)
    }
    
    func test_CRUD_delete() {
        if let connection = connection {
            let cat = Cat()
            cat.name = "Fifi"
            
            try? cat.delete(connection: connection)
            
            XCTAssertEqual(expected_delete_command, connection.query)
            return
        }
        
        XCTAssert(false)
    }
    
    func test_CRUD_read() {
        if let connection = try? MySqlConnectionMock(server: "", database: "", user: "", password: "") {
            
            let params = [String: String]()
            
            if let cats: [Cat] = try? Cat.fill(connection: connection, parameters: params) {
                XCTAssertEqual(connection.query, "SELECT * FROM Cats")
                XCTAssert(cats.count == 2, "Not enough cats")
                XCTAssert(cats[0].name == "Fido", "Wrong cat name")
                return
            }
        }
        
        XCTAssert(false, "Test failed")
    }
}
