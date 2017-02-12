//
//  MySqlReaderProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 08/02/2017.
//
//

import Foundation

public protocol MySqlReaderProtocol {
    var schema: MySqlSchemaProtocol { get }
    var columnNames: [String] { get }
    
    func nextResultSet() throws -> Bool
    func next() -> Bool
    func getString(ordinal: Int) -> String
    func getString(columnName: String) throws -> String

    init(connection: MySqlConnectionProtocol) throws
}
