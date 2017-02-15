import XCTest
import SwiftCMySqlMac
@testable import SwiftMySql

class SwiftMySqlReadAdapterTests: XCTestCase {
    
    func test_adapter_fill() {
        if let connection = try? MySqlConnectionMock(server: "", database: "", user: "", password: "") {
            if let reader = try? MySqlReaderMock(connection: connection) {
                let command = MySqlCommandMock(command: "", connection: connection)
                command.reader = reader
                let adapter = MySqlReadAdapter<Dog>(command: command) {
                    reader in
                    
                    let dog = Dog()
                    dog.name = try? reader.getString(columnName: "name")
                    dog.age = Int(try! reader.getString(columnName: "age"))
                    
                    return dog
                }
                
                let params = [String: String]()
                if let dogs = try? adapter.fill(parameters: params) {
                    XCTAssert(dogs.count == 2, "Not enough dogs")
                    XCTAssert(dogs[0].name == "Fido", "Wrong dog name")
                    return
                }
            }
        }
        
        XCTAssert(false, "Test failed")
    }
    
    private class Dog {
        var name: String?
        var age: Int?
    }
    
    private class MySqlConnectionMock : MySqlConnectionProtocol {
        required init(server: String, database: String, user: String, password: String) throws {
            
        }
        
        func executeSqlQuery(sqlQuery: String) throws {
            
        }
        
        func nextResult() -> Bool {
            return false
        }
        
        func storeResults() throws -> MySqlResultsProtocol {
            throw MySqlErrors.InvalidConnection(error: "")
        }
        
        func setAutoCommit(_ on: Bool) {
            
        }
        
        func rollback() throws {
            
        }
        
        func commit() throws {
            
        }
    }
    
    private class MySqlSchemaMock: MySqlSchemaProtocol {
        var columnMap = [String: MySqlColumn]()
        var numColumns: Int = 0
        var columns = [MySqlColumn]()
        var columnNames = [String]()
        
        func contains(columnName: String) -> Bool {
            return false
        }
        
        func getOrdinalPosition(forColumn: String) -> Int {
            return 0
        }
        
        required init(_ results: MySqlResultsProtocol) {
            
        }
    }
    
    private class MySqlResultsMock: MySqlResultsProtocol {
        var row: MySqlRow?
        func getNextRow() -> Bool {
            return false
        }
        func getString(_ ordinal: Int) -> String {
            return ""
        }
        func getFieldCount() -> Int {
            return 0
        }
        func getFieldInfo(_ ordinal: Int) -> MySqlColumn {
            return MySqlColumn(name: "", length: 0, maxLength: 0, decimals: 0, type: MySqlFieldTypes.bit, ordinal: 0)
        }
    }
    
    private class MySqlReaderMock: MySqlReaderProtocol {
        var schema: MySqlSchemaProtocol = MySqlSchemaMock(MySqlResultsMock())
        var columnNames: [String] = [String]()
        var count = 0
        
        func nextResultSet() throws -> Bool {
            return false
        }
        
        func next() -> Bool {
            count += 1
            return count <= 2
        }
        
        func getString(ordinal: Int) -> String {
            return ""
        }
        
        func getString(columnName: String) throws -> String {
            if count == 1 {
                if columnName == "name" {
                    return "Fido"
                } else {
                    return "2"
                }
            } else {
                if columnName == "name" {
                    return "Pepper"
                } else {
                    return "1"
                }
            }
        }
        
        required init(connection: MySqlConnectionProtocol) throws {
            
        }
    }
    
    private class MySqlCommandMock: MySqlCommandProtocol {
        var reader: MySqlReaderMock?
        
        required init(command: String, connection: MySqlConnectionProtocol) {
            
        }
        
        func execute() throws {
            
        }
        
        func createReader() throws -> MySqlReaderProtocol {
            return reader!
        }
        
        func addParameter(name: String, value: String) {
            
        }
        
        func clearParameters() {
            
        }
    }
    
}
