//
//  MySqlCreateAdapterProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 17/02/2017.
//
//

import Foundation

public protocol MySqlCreateAdapterProtocol {
    var createParameters: [String: String] { get }
    var createCommandText: String { get }
    func create(connection: MySqlConnectionProtocol) throws
}

public extension MySqlCreateAdapterProtocol {
    public func create(connection: MySqlConnectionProtocol) throws {
        let command = MySqlCommand(command: createCommandText, connection: connection)
        
        let params = createParameters
        params.forEach({command.addParameter(name: $0.key, value: $0.value)})
        
        try command.execute()
    }
}
