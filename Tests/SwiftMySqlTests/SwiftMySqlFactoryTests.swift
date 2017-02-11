import XCTest
import SwiftCMySqlMac
@testable import SwiftMySql

class SwiftMySqlFactoryTests: XCTestCase {
    private class ResultsMock: MySqlResultsProtocol {
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
    
    private class ConnectionMock: MySqlConnectionProtocol {
        let server: String
        let database: String
        let user: String
        let password: String
        
        required init(server: String, database: String, user: String, password: String) throws {
            self.server = server
            self.database = database
            self.user = user
            self.password = password
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
            return false
        }
        
        func storeResults() throws -> MySqlResultsProtocol {
            return ResultsMock()
        }
    }
    
    func test_MySqlFactory_createConnection() {
        MySqlFactory.connectionClosure = {
            server, database, user, password in
            return try! ConnectionMock(server: server, database: database, user: user, password: password)
        }
        
        let expectedServer = "server"
        let expectedDatabase = "database"
        let expectedUser = "user"
        let expectedPassword = "password"
        
        let connection = try? MySqlFactory.createConnection(server: expectedServer, database: expectedDatabase, user: expectedUser, password: expectedPassword)
        
        XCTAssertNotNil(connection)
        
        let mock: ConnectionMock = connection as! ConnectionMock
        XCTAssertEqual(expectedServer, mock.server)
        XCTAssertEqual(expectedDatabase, mock.database)
        XCTAssertEqual(expectedUser, mock.user)
        XCTAssertEqual(expectedPassword, mock.password)
    }
}
