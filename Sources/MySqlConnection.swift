//
//  Connection.swift
//  mysql_ui
//
//  Created by William Burton on 01/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlConnection: MySqlConnectionProtocol, MySqlConnectionTransactionProtocol {
    
    private let mysql: UnsafeMutablePointer<MYSQL>?
    
    required init(server: String, database: String, user: String, password: String) throws {
        if let mysql = mysql_init(nil) {
            if mysql_real_connect(mysql, server, user, password, database, 0, nil, CLIENT_MULTI_STATEMENTS) != nil {
                self.mysql = mysql
            } else {
                self.mysql = nil
                throw MySqlErrors.InvalidConnection(error: GetMySqlError())
            }
        } else  {
            self.mysql = nil
            throw MySqlErrors.InvalidConnection(error: GetMySqlError())
        }
    }
    
    private func GetMySqlError() -> String {
        if let error = mysql_error(mysql), let str = String(utf8String: UnsafePointer<CChar>(error)) {
            return str
        } else  {
            return "An error occurred in MySQL"
        }
    }
    
    func executeSqlQuery(sqlQuery: String) throws {
        if mysql_query(mysql, sqlQuery) != 0 {
            throw MySqlErrors.CommandError(error: GetMySqlError())
        }
    }
    
    func nextResult() -> Bool {
        return mysql_next_result(mysql) == 0
    }
    
    func storeResults() throws -> MySqlResultsProtocol {
        if let results = mysql_store_result(mysql) {
            return MySqlResults(results)
        } else {
            throw MySqlErrors.ReaderError(error: GetMySqlError())
        }
    }
    
    func setAutoCommit(_ on: Bool) {
        let ac = on ? 1 : 0
        mysql_autocommit(mysql, my_bool(ac))
    }
    
    func rollback() throws {
        if mysql_rollback(mysql) != 0 {
            throw MySqlErrors.TransactionError(error: GetMySqlError())
        }
    }
    
    func commit() throws {
        if mysql_commit(mysql) != 0 {
            throw MySqlErrors.TransactionError(error: GetMySqlError())
        }
    }
    
    deinit {
        if let mysql = mysql {
            mysql_close(mysql)
        }
    }
}
