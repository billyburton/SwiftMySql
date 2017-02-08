//
//  MySqlCommandProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 08/02/2017.
//
//

import Foundation

public protocol MySqlCommandProtocol {
    init(command: String, connection: MySqlConnectionProtocol)
    func execute() throws
    func createReader() throws -> MySqlReaderProtocol
}
