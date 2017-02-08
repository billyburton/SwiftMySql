//
//  MySqlConnectionTransactionProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 08/02/2017.
//
//

import Foundation

protocol MySqlConnectionTransactionProtocol {
    func setAutoCommit(_ on: Bool)
    func rollback() throws   
    func commit() throws
}
