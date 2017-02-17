//
//  MySqlDeleteAdapterProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 17/02/2017.
//
//

import Foundation

public protocol MySqlDeleteAdapterProtocol {
    var deleteParameters: [String: String] { get }
    var deleteCommandText: String { get }
    func delete(connection: MySqlConnectionProtocol) throws
}

public extension MySqlDeleteAdapterProtocol {
    func delete(connection: MySqlConnectionProtocol) throws {
        let command = MySqlCommand(command: deleteCommandText, connection: connection)
        
        let params = deleteParameters
        params.forEach({command.addParameter(name: $0.key, value: $0.value)})
        
        try command.execute()
    }
}
