//
//  MySqlAdapterCreationProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 17/02/2017.
//
//

import Foundation

public protocol MySqlReadAdapterProtocol {
    static func fill<T: MySqlReadAdapterProtocol>(connection: MySqlConnectionProtocol, parameters: [String: String]) throws -> [T]
    static func build(reader: MySqlReaderProtocol) throws -> MySqlReadAdapterProtocol
    static func createCommand(connection: MySqlConnectionProtocol) -> MySqlCommandProtocol
    static var readCommandText: String { get }
}

public extension MySqlReadAdapterProtocol {
    public static func fill<T: MySqlReadAdapterProtocol>(connection: MySqlConnectionProtocol, parameters: [String: String]) throws -> [T] {
        var items = [T]()

        let command = createCommand(connection: connection)
        
        parameters.forEach({command.addParameter(name: $0.key, value: $0.value)})
        
        let reader = try command.createReader()
        
        while reader.next() {
            if let obj = try T.build(reader: reader) as? T {
                items.append(obj)
            }
        }
        
        return items
    }
    
    public static func createCommand(connection: MySqlConnectionProtocol) -> MySqlCommandProtocol {
        return MySqlCommand(command: readCommandText, connection: connection)
    }
}
