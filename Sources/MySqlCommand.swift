//
//  MySqlCommand.swift
//  mysql_ui
//
//  Created by William Burton on 01/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlCommand: MySqlCommandProtocol {
    
    private let command: String
    private let connection: MySqlConnectionProtocol
    
    required init(command: String, connection: MySqlConnectionProtocol) {
        self.command = command
        self.connection = connection
    }
    
    private func commandExecute() throws {
        try connection.executeSqlQuery(sqlQuery: command)
    }
    
    /**
     Runs a SQL query against the database specified by the MySqlConnection.
     */
    public func execute() throws {
        try self.commandExecute()
        
        while connection.nextResult() {
            
        }
    }
    
    /**
     Creates a MySqlReaderProtocol instance using the current SQL query and connection.
    */
    public func createReader() throws -> MySqlReaderProtocol {
        try self.commandExecute()
    
        return try MySqlFactory.createReader(connection: connection)
    }
}
