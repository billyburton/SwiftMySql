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
    func executeSqlQuery(sqlQuery: String) throws
    func nextResult() -> Bool
    func storeResults() throws -> UnsafeMutablePointer<MYSQL_RES>
}
