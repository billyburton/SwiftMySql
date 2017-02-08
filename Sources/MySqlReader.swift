//
//  MySqlReader.swift
//  mysql_ui
//
//  Created by William Burton on 01/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlReader {

    private let connection: MySqlConnectionProtocol
    private var results: MySqlResults

    let schema: MySqlSchema
    
    init(connection: MySqlConnectionProtocol) throws {
        self.connection = connection
        
        try results = MySqlResults(connection: connection)
        self.schema = MySqlSchema(results: results.results)
    }
    
    func nextResultSet() throws -> Bool {
        if connection.nextResult() {
            try results = MySqlResults(connection: connection)
            return true
        }
        
        return false
    }
    
    func next() -> Bool {
        return results.getNextRow()
    }
    
    func getString(ordinal: Int) -> String {
        return results.getString(ordinal)
    }
    
    func getString(columnName: String) throws -> String {
        let ordinal = schema.getOrdinalPosition(forColumn: columnName)
        
        if ordinal == -1 {
            throw MySqlErrors.InvalidColumnSpecified
        }
        
        return getString(ordinal: ordinal)
    }
}
