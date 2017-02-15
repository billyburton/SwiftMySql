//
//  MySqlReadAdapter.swift
//  SwiftMySql
//
//  Created by William Burton on 14/02/2017.
//
//

import Foundation

public class MySqlReadAdapter<T> {
    private let command: MySqlCommandProtocol
    private let adapter: (MySqlReaderProtocol) -> (T)

    public init(command: MySqlCommandProtocol, adapter: @escaping (MySqlReaderProtocol) -> (T)) {
        self.command = command
        self.adapter = adapter
    }
    
    public func fill(parameters: [String: String]) throws -> [T] {
        command.clearParameters()
        
        for parameter in parameters {
            command.addParameter(name: parameter.key, value: parameter.value)
        }
        
        let reader = try command.createReader()
        
        var items = [T]()
        
        while reader.next() {
            items.append(adapter(reader))
        }
        
        return items
    }
}
