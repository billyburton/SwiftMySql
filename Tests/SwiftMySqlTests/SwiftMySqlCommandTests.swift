import XCTest
import SwiftCMySqlMac
@testable import SwiftMySql

class SwiftMySqlCommandTests: XCTestCase {
    
    //MARK: Mocks
    
    private enum TestErrors: Error {
        case testError, failError
    }
    
    private class MySqlReaderMock: MySqlReaderProtocol {
        lazy var schema: MySqlSchemaProtocol = MySqlSchema(MySqlResultsMock())
        var columnNames: [String] = [String]()
        
        func nextResultSet() throws -> Bool {
            return false
        }
        
        func next() -> Bool {
            return false
        }
        
        func getString(ordinal: Int) -> String {
            return ""
        }
        
        func getString(columnName: String) throws -> String {
            return ""
        }
        
        required init(connection: MySqlConnectionProtocol) throws {
            
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
    
    private class MySqlConnectionMock: MySqlConnectionProtocol {
        var query: String?
        var executeSqlQueryCalled = false
        var shouldThrowError = false
        
        required init(server: String, database: String, user: String, password: String) {
            
        }
        
        func setAutoCommit(_ on: Bool) {
        }
        
        func rollback() throws {
        }
        
        func commit() throws {
        }

        func executeSqlQuery(sqlQuery: String) throws {
            if shouldThrowError {
                throw TestErrors.testError
            }
            
            executeSqlQueryCalled = true
            query = sqlQuery
        }
        
        func nextResult() -> Bool {
            return false
        }
        
        func storeResults() throws -> MySqlResultsProtocol {
            return MySqlResultsMock()
        }
    }
    
    //MARK: Setup
    override func setUp() {
        MySqlFactory.readerClosure = {
            connection in
            return try! MySqlReaderMock(connection: connection)
        }
    }
    
    //MARK: Execute tests
    func test_MySqlCommand_execute_calls_connection_executeSqlQuery() {
        let connection = MySqlConnectionMock(server: "", database: "", user: "", password: "")
        let command = MySqlCommand(command: "", connection: connection)
        try? command.execute()
        
        XCTAssertTrue(connection.executeSqlQueryCalled, "MySqlCommand execute should call MySqlConnection executeSqlQuery")
    }
    
    func test_MySqlCommand_execute_passes_query_to_executeSqlQuery() {
        let connection = MySqlConnectionMock(server: "", database: "", user: "", password: "")
        
        let expectedQuery = "SELECT * FROM Cars"
        let command = MySqlCommand(command: expectedQuery, connection: connection)
        
        try? command.execute()
        
        XCTAssertEqual(expectedQuery, connection.query)
    }
    
    func test_MySqlCommand_execute_throws_error() {
        let connection = MySqlConnectionMock(server: "", database: "", user: "", password: "")
        let command = MySqlCommand(command: "", connection: connection)
        
        connection.shouldThrowError = true
        do {
            try command.execute()
            XCTAssertTrue(false, "Error should be thrown")
        } catch TestErrors.testError {
            XCTAssertTrue(true)
        } catch {
            XCTAssertTrue(false, "Error should be a TestErrors.testError")
        }
    }
    
    //MARK: createReader tests
    func test_MySqlCommand_createReader_calls_connection_executeSqlQuery() {
        let connection = MySqlConnectionMock(server: "", database: "", user: "", password: "")
        let command = MySqlCommand(command: "", connection: connection)
        
        _ = try? command.createReader()
        
        XCTAssertTrue(connection.executeSqlQueryCalled, "MySqlCommand createReader should call MySqlConnection executeSqlQuery")
    }
    
    func test_MySqlCommand_createReader_passes_queryt_to_executeSqlQuery() {
        let expectedQuery = "SELECT * FROM TABLE"
        let connection = MySqlConnectionMock(server: "", database: "", user: "", password: "")
        let command = MySqlCommand(command: expectedQuery, connection: connection)

        _ = try? command.createReader()
        
        XCTAssertEqual(expectedQuery, connection.query)
    }
    
    func test_MySqlCommand_createReader_returns_MySqlReaderProtocol() {
        let connection = MySqlConnectionMock(server: "", database: "", user: "", password: "")
        let command = MySqlCommand(command: "", connection: connection)
        
        if let _ = try? command.createReader() {
            XCTAssertTrue(true)
        } else {
            XCTAssertTrue(false, "command.createReader did not return a MySqlReaderProtocol instance")
        }
    }
    
    func test_MySqlCommand_set_command_string() {
        let expectedCommand = "SELECT * FROM Cars"
        
        let connection = MySqlConnectionMock(server: "", database: "", user: "", password: "")
        let command = MySqlCommand(command: expectedCommand, connection: connection)
        
        XCTAssertEqual(expectedCommand, command.command, "MySqlCommand init did not set command text")
    }
    
    func test_MySqlCommand_addParameter() {
        let connection = MySqlConnectionMock(server: "", database: "", user: "", password: "")
        let command = MySqlCommand(command: "", connection: connection)
        
        command.addParameter(name: "", value: "")
        
        XCTAssertEqual(1, command.parameters.count, "Parameter has not been added to MySqlCommand")
    }
    
    func test_MySqlCommand_clearParameters() {
        let connection = MySqlConnectionMock(server: "", database: "", user: "", password: "")
        let command = MySqlCommand(command: "", connection: connection)
        
        command.addParameter(name: "", value: "")
        command.clearParameters()
        
        XCTAssertEqual(0, command.parameters.count, "Parameter has not been added to MySqlCommand")
    }
    
    func test_MySqlCommand_setParameters() {
        let expectedCommand = "Select * from Cars where Name = 'Audi'"
        
        let connection = MySqlConnectionMock(server: "", database: "", user: "", password: "")
        let command = MySqlCommand(command: "Select * from Cars where Name = @Name", connection: connection)
        
        command.addParameter(name: "@Name", value: "Audi")
        try? command.execute()

        XCTAssertEqual(expectedCommand, connection.query, "Command should be \(expectedCommand) but is \(command.command)")
    }
}
