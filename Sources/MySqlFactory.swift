//
//  MySqlFactory.swift
//  SwiftMySql
//
//  Created by William Burton on 08/02/2017.
//
//

import Foundation

public class MySqlFactory {
    //MARK: connection factory
    static var connectionClosure: (String, String, String, String) throws -> (MySqlConnectionProtocol) = {
        server, database, user, password in
        return try MySqlConnection(server: server, database: database, user: user, password: password)
    }

    public class func createConnection(server: String, database: String, user: String, password: String) throws -> MySqlConnectionProtocol {
        return try connectionClosure(server, database, user, password)
    }
    
    //MARK: reader factory
    static var readerClosure: (MySqlConnectionProtocol) throws -> (MySqlReaderProtocol) = {
        connection in
        return try MySqlReader(connection: connection)
    }

    public class func createReader(connection: MySqlConnectionProtocol) throws -> MySqlReaderProtocol {
        return try readerClosure(connection)
    }
    
    //MARK: command factory
    static var commandClosure: (String, MySqlConnectionProtocol) -> (MySqlCommandProtocol) = {
        command, connection in
        return MySqlCommand(command: command, connection: connection)
    }
    
    public class func createCommand(command: String, connection: MySqlConnectionProtocol) -> MySqlCommandProtocol {
        return commandClosure(command, connection)
    }
    
    //MARK: schema factory
    static var schemaClosure: (MySqlResultsProtocol) -> (MySqlSchemaProtocol) = {
        results in
        return MySqlSchema(results)
    }
    
    public class func createSchema(results: MySqlResultsProtocol) -> MySqlSchemaProtocol {
        return schemaClosure(results)
    }
}
