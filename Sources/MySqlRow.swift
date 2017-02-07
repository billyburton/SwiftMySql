//
//  MySqlRow.swift
//  mysql_ui
//
//  Created by William Burton on 01/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlRow {
    private let theRow: MYSQL_ROW
    private let schema: MySqlSchema
    
    init(row: MYSQL_ROW, schema: MySqlSchema) {
        self.theRow = row
        self.schema = schema
    }
    
    func getString(ordinal: Int) -> String? {
        if let field = theRow[ordinal] {
            if let str = String(utf8String: field) {
                return str
            }
        }
        
        return nil
    }
    
    func getString(fieldName: String) -> String? {
        if let ord = schema.columnMap[fieldName]?.ordinal {
            return getString(ordinal: ord)
        } else {
            return ""
        }
    }
}
