//
//  MySqlResults.swift
//  mysql_ui
//
//  Created by William Burton on 05/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlResults: MySqlResultsProtocol {
    
    let results: UnsafeMutablePointer<MYSQL_RES>
    var row: MySqlRow?
    
    init(_ results: UnsafeMutablePointer<MYSQL_RES>) {
        self.results = results
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

    func getFieldCount() -> Int {
        return Int(mysql_num_fields(results))
    }
    
    func getFieldInfo(_ ordinal: Int) -> MySqlColumn {
        if let field: MYSQL_FIELD = mysql_fetch_field(results)?.pointee {
            let name = String(utf8String: UnsafePointer<CChar>(field.name)) ?? ""
            let type = MySqlFieldTypes(rawValue: Int(field.type.rawValue)) ?? MySqlFieldTypes.undefined
            
            return MySqlColumn(name: name,
                               length: field.length,
                               maxLength: field.max_length,
                               decimals: field.decimals,
                               type: type,
                               ordinal: ordinal)
        }
        
        return MySqlColumn(name: "", length: 0, maxLength: 0, decimals: 0, type: MySqlFieldTypes.undefined, ordinal: ordinal)
    }

    deinit {
        mysql_free_result(results)
    }
}
