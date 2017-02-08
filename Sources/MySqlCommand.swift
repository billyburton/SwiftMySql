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
    let connection: MySqlConnectionProtocol
    
    init(command: String, connection: MySqlConnectionProtocol) {
        self.command = command
        self.connection = connection
    }
    
    private func commandExecute() throws {
        try connection.executeSqlQuery(sqlQuery: command)
    }
    
    func execute() throws {
        try self.commandExecute()
        
        while connection.nextResult() {
            
        }
    }
    
    func createReader() throws -> MySqlReader {
        try self.commandExecute()
    
        return try MySqlReader(connection: connection)
    }
}
