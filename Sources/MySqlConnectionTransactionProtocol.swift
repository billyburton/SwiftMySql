//
//  MySqlConnectionTransactionProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 08/02/2017.
//
//

import Foundation

protocol MySqlConnectionTransactionProtocol: MySqlConnectionProtocol {
    init(server: String, database: String, user: String, password: String) throws
    func setAutoCommit(_ on: Bool)
    func rollback() throws   
    func commit() throws
}
