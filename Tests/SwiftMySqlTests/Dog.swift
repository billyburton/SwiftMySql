//
//  Dog.swift
//  SwiftMySql
//
//  Created by William Burton on 17/02/2017.
//
//

import Foundation
import SwiftMySql

class Dog {
    var name: String?
    var age: Int?
}

extension Dog: MySqlReadAdapterProtocol {
    public static var readCommandText: String {
        return "SELECT * FROM Dogs"
    }

    static func build() -> MySqlReadAdapterProtocol {
        return Dog()
    }
    
    static func createCommand(connection: MySqlConnectionProtocol) -> MySqlCommandProtocol {
        let reader = try? MySqlReaderMock(connection: connection)
        let command = MySqlCommandMock(command: readCommandText, connection: connection)
        command.reader = reader!
        return command
    }
    
    func setValues(reader: MySqlReaderProtocol) {
        self.name = try? reader.getString(columnName: "name")
    }
}

extension Dog: MySqlCreateAdapterProtocol {
    public var createCommandText: String {
        return "INSERT INTO Dogs VALUES (@name, @age)"
    }

    var createParameters: [String : String] {
        return ["@name": self.name!, "@age": String(describing: self.age!)]
    }
}

extension Dog: MySqlUpdateAdapterProtocol {
    public var updateCommandText: String {
        return "UPDATE Dogs SET Age = @age WHERE Name = @name"
    }

    var updateParameters: [String: String] {
        return ["@name": self.name!, "@age": String(describing: self.age!)]
    }
}

extension Dog: MySqlDeleteAdapterProtocol {
    public var deleteCommandText: String {
        return "DELETE FROM Dogs WHERE Name = 'Fido'"
    }

    var deleteParameters: [String: String] {
        return ["@name": self.name!]
    }
}
