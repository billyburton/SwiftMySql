//
//  MySqlResultsProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 08/02/2017.
//
//

import Foundation
import SwiftCMySqlMac

protocol MySqlResultsProtocol {
    var row: MySqlRow? { get }
    func getNextRow() -> Bool
    func getString(_ ordinal: Int) -> String
    func getFieldCount() -> Int
    func getFieldInfo(_ ordinal: Int) -> MySqlColumn
}
