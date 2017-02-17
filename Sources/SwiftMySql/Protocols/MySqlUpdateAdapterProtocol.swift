//
//  MySqlUpdateAdapterProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 17/02/2017.
//
//

import Foundation

public protocol MySqlUpdateAdapterProtocol {
    var updateParameters: [String: String] { get }
    var updateCommandText: String { get }
    func update(connection: MySqlConnectionProtocol) throws
}

public extension MySqlUpdateAdapterProtocol {
    public func update(connection: MySqlConnectionProtocol) throws {
        let command = MySqlCommand(command: updateCommandText, connection: connection)
        
        let params = updateParameters
        params.forEach({command.addParameter(name: $0.key, value: $0.value)})
        
        try command.execute()
    }
}
