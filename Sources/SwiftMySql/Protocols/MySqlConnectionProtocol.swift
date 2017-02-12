//
//  MySqlConnectionProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 08/02/2017.
//
//

import Foundation
import SwiftCMySqlMac

/**
 Provides methods used for working with a connection to a MySql database.
 */
public protocol MySqlConnectionProtocol {
    init(server: String, database: String, user: String, password: String) throws
    func executeSqlQuery(sqlQuery: String) throws
    func nextResult() -> Bool
    func storeResults() throws -> MySqlResultsProtocol
    func setAutoCommit(_ on: Bool)
    func rollback() throws
    func commit() throws
}
