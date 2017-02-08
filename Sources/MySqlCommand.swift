//
//  MySqlCommand.swift
//  mysql_ui
//
//  Created by William Burton on 01/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

public class MySqlCommand {
    
    let command: String
    let connection: MySqlConnectionProtocol
    
    public init(command: String, connection: MySqlConnectionProtocol) {
        self.command = command
        self.connection = connection
    }
    
    private func commandExecute() throws {
        try connection.executeSqlQuery(sqlQuery: command)
    }
    
    public func execute() throws {
        try self.commandExecute()
        
        while connection.nextResult() {
            
        }
    }
    
    public func createReader() throws -> MySqlReader {
        try self.commandExecute()
    
        return try MySqlReader(connection: connection)
    }
}
