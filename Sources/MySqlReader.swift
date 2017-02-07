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

    private let connection: MySqlConnection
    private var results: MySqlResults

    let schema: MySqlSchema
    var row: MySqlRow?
    
    
    init(connection: MySqlConnection) throws {
        self.connection = connection
        
        try results = MySqlResults(connection: connection)
        self.schema = MySqlSchema(results: results.results)
    }
    
    func nextResultSet() throws -> Bool {
        if mysql_next_result(connection.TheConnection) == 0 {
            try results = MySqlResults(connection: connection)
            return true
        }
        
        return false
    }
    
    func next() -> Bool {
        if let row: MYSQL_ROW = mysql_fetch_row(results.results) {
            self.row = MySqlRow(row: row, schema: schema)
            return true
        }
    
        return false
    }
}
