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

    /**
     Factory method for creating a MySqlConnectionProtocol instance.
     
     - throws: 
        An error of type MySqlError.InvalidConnection.
     
     - parameters: 
        - server: Name of the MySql server.
        - database: Name of the MySql database.
        - user: Name of user that will be used to access the database.
        - password: Password of the MySql user.
     
     - returns: 
        An instance of MySqlConnectionProtocol.
     */
    public class func createConnection(server: String, database: String, user: String, password: String) throws -> MySqlConnectionProtocol {
        return try connectionClosure(server, database, user, password)
    }
    
    //MARK: Transaction factory
    static var transactionClosure: (MySqlConnectionProtocol) -> (MySqlTransactionProtocol) = {
        connection in
        return MySqlTransaction(connection: connection)
    }
    
    /**
     Factory method for creating a MySqlTransactionProtocol instance
     
     - parameters: 
        - connection: An instance of MySqlConnectionProtocol created using the createConnection method.
     
     - returns: 
        An instance of MySqlTransactionProtocol
     
     */
    public class func createTransaction(connection: MySqlConnectionProtocol) -> (MySqlTransactionProtocol) {
        return transactionClosure(connection)
    }
    
    //MARK: reader factory
    static var readerClosure: (MySqlConnectionProtocol) throws -> (MySqlReaderProtocol) = {
        connection in
        return try MySqlReader(connection: connection)
    }

    /**
     Factory method for creating a MySqlReaderProtocol
     
     - throws: 
        An error of type MySqlError.ReaderError
     
     - parameters: 
        - connection: An instance of MySqlConnectionProtocol created using the createConnection method.
     
     - returns: 
        An instance of MySqlReaderProtocol
     
     */
    class func createReader(connection: MySqlConnectionProtocol) throws -> MySqlReaderProtocol {
        return try readerClosure(connection)
    }
    
    //MARK: command factory
    static var commandClosure: (String, MySqlConnectionProtocol) -> (MySqlCommandProtocol) = {
        command, connection in
        return MySqlCommand(command: command, connection: connection)
    }
    
    /**
     Factory method for creating a MySqlCommandProtocol
     
     - parameters:
        - command: Sql query command.
        - connection: An instance of MySqlConnectionProtocol created using the createConnection method
     
     - returns: 
        An instance of MySqlCommandProtocol
     
    */
    public class func createCommand(command: String, connection: MySqlConnectionProtocol) -> MySqlCommandProtocol {
        return commandClosure(command, connection)
    }
    
    //MARK: schema factory
    static var schemaClosure: (MySqlResultsProtocol) -> (MySqlSchemaProtocol) = {
        results in
        return MySqlSchema(results)
    }
    
    /**
     Factory method for creating a MySqlSchemaProtocol
     
     - parameters: 
        - results: An instance of MySqlResultsProtocol, that contains a resultset returned from the MySql database.
     
     - returns: 
        An instance of MySqlSchemaProtocol
     
     */
    class func createSchema(results: MySqlResultsProtocol) -> MySqlSchemaProtocol {
        return schemaClosure(results)
    }
}
