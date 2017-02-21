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
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

extension Dog: MySqlReadAdapterProtocol {
    public static func build(reader: MySqlReaderProtocol) throws -> MySqlReadAdapterProtocol {
        do {
            let name = try reader.getString(columnName: "name")
            let dog = Dog(name: name, age: 2)
            return dog
        }
    }

    public static var readCommandText: String {
        return "SELECT * FROM Dogs"
    }

    static func createCommand(connection: MySqlConnectionProtocol) -> MySqlCommandProtocol {
        let reader = try? MySqlReaderMock(connection: connection)
        let command = MySqlCommandMock(command: readCommandText, connection: connection)
        command.reader = reader!
        return command
    }
}

extension Dog: MySqlCreateAdapterProtocol {
    public var createCommandText: String {
        return "INSERT INTO Dogs VALUES (@name, @age)"
    }

    var createParameters: [String : String] {
        return ["@name": self.name, "@age": String(describing: self.age)]
    }
}

extension Dog: MySqlUpdateAdapterProtocol {
    public var updateCommandText: String {
        return "UPDATE Dogs SET Age = @age WHERE Name = @name"
    }

    var updateParameters: [String: String] {
        return ["@name": self.name, "@age": String(describing: self.age)]
    }
}

extension Dog: MySqlDeleteAdapterProtocol {
    public var deleteCommandText: String {
        return "DELETE FROM Dogs WHERE Name = 'Fido'"
    }

    var deleteParameters: [String: String] {
        return ["@name": self.name]
    }
}
