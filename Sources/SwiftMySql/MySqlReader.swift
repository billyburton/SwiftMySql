//
//  MySqlReader.swift
//  mysql_ui
//
//  Created by William Burton on 01/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlReader: MySqlReaderProtocol {

    private let connection: MySqlConnectionProtocol
    private var results: MySqlResultsProtocol

    lazy var schema: MySqlSchemaProtocol = MySqlFactory.createSchema(results: self.results)
    
    public var columnNames: [String] {
        get {
            return schema.columnNames
        }
    }
    
    required init(connection: MySqlConnectionProtocol) throws {
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
    
    public func next() -> Bool {
        return results.getNextRow()
    }
    
    public func getString(ordinal: Int) -> String {
        return results.getString(ordinal)
    }
    
    public func getString(columnName: String) throws -> String {
        let ordinal = schema.getOrdinalPosition(forColumn: columnName)
        
        if ordinal == -1 {
            throw MySqlErrors.InvalidColumnSpecified
        }
        
        return getString(ordinal: ordinal)
    }
}
