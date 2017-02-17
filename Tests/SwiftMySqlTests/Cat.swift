//
//  Cat.swift
//  SwiftMySql
//
//  Created by William Burton on 17/02/2017.
//
//

import Foundation
import SwiftMySql

class Cat {
    var name: String?
}

extension Cat: MySqlCRUDAdapterProtocol {
    public static var readCommandText: String {
        return "SELECT * FROM Cats"
    }
    
    public static func createCommand(connection: MySqlConnectionProtocol) -> MySqlCommandProtocol {
        let command = MySqlCommandMock(command: readCommandText, connection: connection)
        let reader = try? MySqlReaderMock(connection: connection)
        command.reader = reader!
        return command
    }

    public var deleteCommandText: String {
        return "DELETE FROM Cats WHERE Name = 'Fifi'"
    }

    public var updateCommandText: String {
        return "UPDATE Cats Set Name = @name WHERE Name = @name"
    }

    public var createCommandText: String {
        return "INSERT INTO Cats VALUES (@name)"
    }

    func getParams() -> [String: String] {
        return ["@name": self.name!]
    }
    
    static func build() -> MySqlReadAdapterProtocol {
        return Cat()
    }
    
    func setValues(reader: MySqlReaderProtocol) {
        self.name = try? reader.getString(columnName: "name")
    }
    
    var createParameters: [String: String] {
        return getParams()
    }
    
    var updateParameters: [String: String] {
        return getParams()
    }
    
    var deleteParameters: [String: String] {
        return getParams()
    }
}
