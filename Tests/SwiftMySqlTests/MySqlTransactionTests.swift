import XCTest
import SwiftCMySqlMac
@testable import SwiftMySql

class MySqlTransactionTests: XCTestCase {
    //MARK: Mocks
    private class MySqlConnectionMock: MySqlConnectionProtocol {
        var autoCommitWasCalled = false
        var rollbackWasCalled = false
        var rollbackShouldThrowError = false
        var commitWasCalled = false
        var commitShouldThrowError = false
        
        required init(server: String, database: String, user: String, password: String) throws {
            
        }
        
        func setAutoCommit(_ on: Bool) {
            autoCommitWasCalled = true
        }
        
        func rollback() throws {
            if rollbackShouldThrowError {
                throw MySqlErrors.TransactionError(error: "Test error")
            }
            rollbackWasCalled = true
        }
        
        func commit() throws {
            if commitShouldThrowError {
                throw MySqlErrors.TransactionError(error: "Test error")
            }
            commitWasCalled = true
        }

        func executeSqlQuery(sqlQuery: String) throws {
            
        }
        
        func nextResult() -> Bool {
            return false
        }
        
        func storeResults() throws -> MySqlResultsProtocol {
            let res: UnsafeMutablePointer<MYSQL_RES>? = nil
            return MySqlResults(res!)
        }
    }
    
    //MARK: Setup
    private var connection: MySqlConnectionMock?
    
    override func setUp() {
        connection = try? MySqlConnectionMock(server: "", database: "", user: "", password: "")
    }
    
    //MARK: Tests
    func test_MySqlTransaction_init() {
        if let connection = connection {
            _ = MySqlTransaction(connection: connection)
            XCTAssertTrue(connection.autoCommitWasCalled, "connecction.setAutoCommit should have been called")
        }
    }
    
    func test_MySqlTransaction_rollback() {
        if let connection = connection {
            let transaction = MySqlTransaction(connection: connection)
            try? transaction.rollback()
            XCTAssertTrue(connection.rollbackWasCalled, "connecction.rollback should have been called")
        }
    }

    func test_MySqlTransaction_rollback_throws() {
        if let connection = connection {
            connection.rollbackShouldThrowError = true
            
            let transaction = MySqlTransaction(connection: connection)
            do {
                try transaction.rollback()
                XCTAssert(false, "Expected rollback to throw error")
            } catch {
                XCTAssert(true)
            }
        }
    }

    func test_MySqlTransaction_commit() {
        if let connection = connection {
            let transaction = MySqlTransaction(connection: connection)
            try? transaction.commit()
            XCTAssertTrue(connection.commitWasCalled, "connecction.commit should have been called")
        }
    }
    
    func test_MySqlTransaction_commit_throws() {
        if let connection = connection {
            connection.commitShouldThrowError = true
            
            let transaction = MySqlTransaction(connection: connection)
            do {
                try transaction.commit()
                XCTAssert(false, "Expected commit to throw error")
            } catch {
                XCTAssert(true)
            }
        }
    }
    
    func test_MySqlTransaction_deinit() {
        if let connection = connection {
            var transaction: MySqlTransaction? = MySqlTransaction(connection: connection)
            try? transaction!.commit()
            transaction = nil
            
            XCTAssertTrue(connection.commitWasCalled, "connecction.commit should have been called")
            XCTAssertTrue(connection.autoCommitWasCalled, "connecction.autoCommitWasCalled should have been called")
        }
    }
}
