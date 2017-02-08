//
//  MySqlConnectionProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 08/02/2017.
//
//

import Foundation
import SwiftCMySqlMac

protocol MySqlConnectionProtocol {
    init(server: String, database: String, user: String, password: String) throws
    func executeSqlQuery(sqlQuery: String) throws
    func nextResult() -> Bool
    func storeResults() throws -> MySqlResultsProtocol
}