//
//  MySqlResults.swift
//  mysql_ui
//
//  Created by William Burton on 05/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlResults {
    
    let results: UnsafeMutablePointer<MYSQL_RES>
    var row: MySqlRow?
    
    init(connection: MySqlConnectionProtocol) throws {
        try results = connection.storeResults()
    }
    
    func getNextRow() -> Bool {
        if let row: MYSQL_ROW = mysql_fetch_row(results) {
            self.row = MySqlRow(row: row)
            return true
        }
        
        return false
    }
    
    func getString(_ ordinal: Int) -> String {
        guard let row = row else {
            return ""
        }
        
        return row.getString(ordinal) ?? ""
    }
    
    deinit {
        mysql_free_result(results)
    }
}
