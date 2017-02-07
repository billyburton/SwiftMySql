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
    
    init(connection: MySqlConnection) throws {
        if let results = mysql_store_result(connection.TheConnection) {
            self.results = results
        } else {
            throw MySqlErrors.ReaderError(error: GetMySqlError(connection: connection.TheConnection))
        }
    }
    
    deinit {
        mysql_free_result(results)
    }
}
