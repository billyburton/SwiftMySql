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
    static func build() -> MySqlReadAdapterProtocol
    static func createCommand(connection: MySqlConnectionProtocol) -> MySqlCommandProtocol
    static var readCommandText: String { get }
    func setValues(reader: MySqlReaderProtocol)
}

public extension MySqlReadAdapterProtocol {
    public static func fill<T: MySqlReadAdapterProtocol>(connection: MySqlConnectionProtocol, parameters: [String: String]) throws -> [T] {
        var items = [T]()

        let command = createCommand(connection: connection)
        
        parameters.forEach({command.addParameter(name: $0.key, value: $0.value)})
        
        let reader = try command.createReader()
        
        while reader.next() {
            if let obj = T.build() as? T {
                obj.setValues(reader: reader)
                items.append(obj)
            }
        }
        
        return items
    }
    
    public static func createCommand(connection: MySqlConnectionProtocol) -> MySqlCommandProtocol {
        return MySqlCommand(command: readCommandText, connection: connection)
    }
}
