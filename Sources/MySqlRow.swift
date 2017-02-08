//
//  MySqlRow.swift
//  mysql_ui
//
//  Created by William Burton on 01/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

public class MySqlRow {
    private let theRow: MYSQL_ROW
    
    init(row: MYSQL_ROW) {
        self.theRow = row
    }
    
    func getString(_ ordinal: Int) -> String? {
        if let field = theRow[ordinal] {
            if let str = String(utf8String: field) {
                return str
            }
        }
        
        return nil
    }
}
