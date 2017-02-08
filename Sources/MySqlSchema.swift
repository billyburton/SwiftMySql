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
    
    func contains(columnName: String) -> Bool {
        return columnMap[columnName] != nil
    }
    
    func getOrdinalPosition(forColumn: String) -> Int {
        if let column = columnMap[forColumn] {
            return column.ordinal
        }
        
        return -1
    }
    
    init(_ results: MySqlResultsProtocol) {
        numColumns = results.getFieldCount()
        
        var ordMap = [String: MySqlColumn]()

        for ord in 0 ..< numColumns {
            let column = results.getFieldInfo(ord)
            ordMap[column.name] = column
        }
        
        self.columnMap = ordMap
    }
}
