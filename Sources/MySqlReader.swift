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
    private var results: MySqlResultsProtocol

    lazy var schema: MySqlSchema = MySqlSchema(self.results)
    
    init(connection: MySqlConnectionProtocol) throws {
        self.connection = connection
        
        results = try connection.storeResults()
    }
    
    func nextResultSet() throws -> Bool {
        if connection.nextResult() {
            results = try connection.storeResults()
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
