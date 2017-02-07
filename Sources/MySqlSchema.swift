//
//  MySqlSchema.swift
//  mysql_ui
//
//  Created by William Burton on 05/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlSchema {
    let columnMap: [String: MySqlColumn]
    let numColumns: Int
    
    var columns: [MySqlColumn] {
        return [MySqlColumn](columnMap.values)
    }
    
    var columnNames: [String] {
        return [String](columnMap.keys)
    }
    
    var description: String {
        let array: [String] = self.columns.map({$0.description})
        return array.joined(separator: "\n")
    }
    
    init(results: UnsafeMutablePointer<MYSQL_RES>) {
        numColumns = Int(mysql_num_fields(results))
        
        var ordMap = [String: MySqlColumn]()

        for ord in 0 ..< numColumns {
            if let field: MYSQL_FIELD = mysql_fetch_field(results)?.pointee {
                let column = MySqlColumn(field: field, ordinal: ord)
                ordMap[column.name] = column
            }
        }
        
        self.columnMap = ordMap
    }
}
