//
//  MySqlCommand.swift
//  mysql_ui
//
//  Created by William Burton on 01/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlCommand {
    
    let command: String
    let connection: MySqlConnection
    
    init(command: String, connection: MySqlConnection) {
        self.command = command
        self.connection = connection
    }
    
    private func commandExecute() throws {
        if let mysql = connection.TheConnection {
            if mysql_query(mysql, command) != 0 {
                throw MySqlErrors.CommandError(error: GetMySqlError(connection: mysql))
            }
        } else {
            throw MySqlErrors.InvalidConnection(error: GetMySqlError(connection: nil))
        }
    }
    
    func execute() throws {
        try self.commandExecute()
        
        while mysql_next_result(connection.TheConnection) == 0 {
            
        }
    }
    
    func createReader() throws -> MySqlReader {
        try self.commandExecute()
    
        return try MySqlReader(connection: connection)
    }
}
