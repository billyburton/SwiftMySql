//
//  MySqlTransactionProtocol.swift
//  SwiftMySql
//
//  Created by William Burton on 11/02/2017.
//
//

import Foundation

public protocol MySqlTransactionProtocol {
    func rollback() throws
    func commit() throws
}
