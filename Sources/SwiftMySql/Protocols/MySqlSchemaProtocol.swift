//
//  MySqlSchemaProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 08/02/2017.
//
//

import Foundation

public protocol MySqlSchemaProtocol {
    var columnMap: [String: MySqlColumn] { get }
    var numColumns: Int { get }
    var columns: [MySqlColumn] { get }
    var columnNames: [String] { get }
    
    func contains(columnName: String) -> Bool
    func getOrdinalPosition(forColumn: String) -> Int
    
    init(_ results: MySqlResultsProtocol)
}
