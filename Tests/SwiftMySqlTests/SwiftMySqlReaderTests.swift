import XCTest
import SwiftCMySqlMac
@testable import SwiftMySql

class SwiftMySqlReaderTests: XCTestCase {
    //MARK: Mocks
    private class MySqlConnectionMock: MySqlConnectionProtocol {
        let expectedMySqlResultsMock: MySqlResultsMock = MySqlResultsMock()
        var storeResultsWasCalled = false
        var storeResultsShouldThrow = false
        var storeResultsError = MySqlErrors.InvalidColumnSpecified
        
        var expectedNextResult = true
        
        required init(server: String, database: String, user: String, password: String) throws {
            
        }
        
        func setAutoCommit(_ on: Bool) {
        }
        
        func rollback() throws {
        }
        
        func commit() throws {
        }
        
        func executeSqlQuery(sqlQuery: String) throws {
            
        }
        
        func nextResult() -> Bool {
            return expectedNextResult
        }
        
        func storeResults() throws -> MySqlResultsProtocol {
            if storeResultsShouldThrow {
                throw storeResultsError
            }
            
            storeResultsWasCalled = true
            return expectedMySqlResultsMock
        }
    }
    
    private class MySqlResultsMock: MySqlResultsProtocol {
        var hasNextRow = true
        var expectedString: String?
        
        var row: MySqlRow?
        
        func getNextRow() -> Bool {
            return hasNextRow
        }
        
        func getString(_ ordinal: Int) -> String {
            return expectedString!
        }
        
        func getFieldCount() -> Int {
            return 0
        }
        
        func getFieldInfo(_ ordinal: Int) -> MySqlColumn {
            return MySqlColumn(name: "", length: 0, maxLength: 0, decimals: 0, type: MySqlFieldTypes.bit, ordinal: 0)
        }
    }
    
    private class MySqlSchemaMock: MySqlSchemaProtocol {
        var expectedColumnNames: [String] = [String]()
        var ordinalPosition = 0
        
        var columnMap: [String: MySqlColumn] = [String: MySqlColumn]()
        var numColumns: Int = 0
        var columns: [MySqlColumn] = [MySqlColumn]()
        var columnNames: [String] {
            get {
                return expectedColumnNames
            }
        }
        
        func contains(columnName: String) -> Bool {
            return false
        }
        
        func getOrdinalPosition(forColumn: String) -> Int {
            return ordinalPosition
        }
        
        required init(_ results: MySqlResultsProtocol) {
        
        }
    }

    private let connection = try? MySqlConnectionMock(server: "", database: "", user: "", password: "")
    
    //MARK: Setup
    override func setUp() {
        
        MySqlFactory.schemaClosure = {
            results in
            return MySqlSchemaMock(results)
        }
    }
    
    //MARK: Tests
    func test_MySqlReader_init() {
        if let connection = connection {
            _ = try? MySqlReader(connection: connection)
            
            XCTAssertTrue(connection.storeResultsWasCalled, "Reader init should called connection.storeResults")
        }
    }
    
    func test_MySqlReader_init_throws() {
        if let connection = connection {
            do {
                connection.storeResultsShouldThrow = true
                _ = try MySqlReader(connection: connection)
                
                XCTAssert(false, "MySqlReader init should throw error")
            } catch {
                XCTAssert(true)
            }
        }
    }
    
    func test_MySqlReader_columnNames() {
        let expectedColumnNames = ["col1", "col2"]
        
        if let connection = connection, let reader = try? MySqlReader(connection: connection) {
            if let schema = reader.schema as? MySqlSchemaMock {
                schema.expectedColumnNames = expectedColumnNames
                XCTAssertEqual(expectedColumnNames, reader.columnNames, "MySqlReader returns wrong column names")
            } else {
                XCTAssert(false, "Error creating schema")
            }
        } else {
            XCTAssert(false, "Error creating reader")
        }
    }

    func test_MySqlReader_nextResultsSet_returns_true() {
        if let connection = connection, let reader = try? MySqlReader(connection: connection), let ret = try? reader.nextResultSet() {
            XCTAssertTrue(ret, "reader.nextResultSet should return true")
        } else {
            XCTAssert(false, "Error creating results")
        }
    }
    
    func test_MySqlReader_nextResultsSet_returns_false() {
        if let connection = connection, let reader = try? MySqlReader(connection: connection) {
            connection.expectedNextResult = false
            if let ret = try? reader.nextResultSet() {
                XCTAssertFalse(ret, "reader.nextResultSet should return false")
            }
        } else {
            XCTAssert(false, "Error creating results")
        }
    }
    
    func test_MySqlReader_nextResultsSet_throws() {
        if let connection = connection, let reader = try? MySqlReader(connection: connection) {
            connection.storeResultsShouldThrow = true
            
            do {
                let _ = try reader.nextResultSet()
                XCTAssert(false, "reader.nextResultSet should throw error")
            } catch {
                XCTAssert(true)
            }
        }
    }
    
    func test_MySqlReader_next_returns_true() {
        if let connection = connection, let reader = try? MySqlReader(connection: connection) {
            let ret = reader.next()
            XCTAssertTrue(ret, "reader.next() should return true")
        }
    }
    
    func test_MySqlReader_next_returns_false() {
        if let connection = connection, let reader = try? MySqlReader(connection: connection) {
            connection.expectedMySqlResultsMock.hasNextRow = false
            
            let ret = reader.next()
            XCTAssertFalse(ret, "reader.next() should return false")
        }
    }
    
    func test_MySqlReader_getString_using_ordinal() {
        let expectedString = "test"
        
        if let connection = connection, let reader = try? MySqlReader(connection: connection) {
            connection.expectedMySqlResultsMock.expectedString = expectedString
            
            let actualString = reader.getString(ordinal: 0)
            
            XCTAssertEqual(expectedString, actualString, "reader.getString returned \(actualString) but should return \(expectedString)")
        }
    }
    
    func test_MySqlReader_getString_using_name() {
        let expectedString = "test"
        
        if let connection = connection, let reader = try? MySqlReader(connection: connection) {
            connection.expectedMySqlResultsMock.expectedString = expectedString
            
            let actualString = try? reader.getString(columnName: "")
            
            XCTAssertEqual(expectedString, actualString, "reader.getString returned \(actualString) but should return \(expectedString)")
        }
    }
    
    func test_MySqlReader_getString_using_name_throws() {
        let expectedString = "test"
        
        if let connection = connection, let reader = try? MySqlReader(connection: connection) {
            if let schema = reader.schema as? MySqlSchemaMock {
                schema.ordinalPosition = -1
                connection.expectedMySqlResultsMock.expectedString = expectedString
            
                do {
                    _ = try reader.getString(columnName: "")
                    XCTAssert(false, "Reader.GetString() should throw error")
                } catch {
                    XCTAssert(true)
                }
            }
        }
    }
}
