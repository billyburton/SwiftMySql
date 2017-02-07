//
//  Connection.swift
//  mysql_ui
//
//  Created by William Burton on 01/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlConnection {
    
    let TheConnection: UnsafeMutablePointer<MYSQL>?
    
    init(server: String, database: String, user: String, password: String) throws {
        if let mysql = mysql_init(nil) {
            if mysql_real_connect(mysql, server, user, password, database, 0, nil, CLIENT_MULTI_STATEMENTS) != nil {
                TheConnection = mysql
            } else {
                TheConnection = nil
                throw MySqlErrors.InvalidConnection(error: GetMySqlError(connection: mysql))
            }
        } else  {
            TheConnection = nil
            throw MySqlErrors.InvalidConnection(error: GetMySqlError(connection: nil))
        }
    }
    
    deinit {
        if let connection = TheConnection {
            mysql_close(connection)
        }
    }
}
