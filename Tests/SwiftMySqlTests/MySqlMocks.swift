//
//  MySqlMocks.swift
//  SwiftMySql
//
//  Created by William Burton on 17/02/2017.
//
//

import Foundation
@testable import SwiftMySql

class MySqlConnectionMock : MySqlConnectionProtocol {
    var query: String = ""
    
    required init(server: String, database: String, user: String, password: String) throws {
        
    }
    
    func executeSqlQuery(sqlQuery: String) throws {
        query = sqlQuery
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

class MySqlSchemaMock: MySqlSchemaProtocol {
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

class MySqlResultsMock: MySqlResultsProtocol {
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

class MySqlReaderMock: MySqlReaderProtocol {
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

class MySqlCommandMock: MySqlCommandProtocol {
    var reader: MySqlReaderMock?
    let commandText: String
    let connection: MySqlConnectionProtocol
    
    required init(command: String, connection: MySqlConnectionProtocol) {
        self.commandText = command
        self.connection = connection
    }
    
    func execute() throws {
        
    }
    
    func createReader() throws -> MySqlReaderProtocol {
        try connection.executeSqlQuery(sqlQuery: commandText)
        return reader!
    }
    
    func addParameter(name: String, value: String) {
        
    }
    
    func clearParameters() {
        
    }
}
 
