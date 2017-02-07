//
//  MySqlTransaction.swift
//  mysql_ui
//
//  Created by William Burton on 04/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlTransaction {
    
    private enum MySqlTransactionState {
        case Open,
             Committed,
             Rolledback
    }
    
    
    let connection: MySqlConnection
    private var state = MySqlTransactionState.Open
    
    init(connection: MySqlConnection) {
        self.connection = connection
        mysql_autocommit(connection.TheConnection, 0)
    }
    
    func rollback() throws {
        if mysql_rollback(connection.TheConnection) != 0 {
            throw MySqlErrors.TransactionError(error: GetMySqlError(connection: connection.TheConnection))
        }
        
        state = MySqlTransactionState.Rolledback
    }
    
    func commit() throws {
        if state != MySqlTransactionState.Open {
            return
        }
        
        if mysql_commit(connection.TheConnection) != 0 {
            throw MySqlErrors.TransactionError(error: GetMySqlError(connection: connection.TheConnection))
        }
        
        state = MySqlTransactionState.Committed
    }

    deinit {
        do {
            try self.commit()
        } catch MySqlErrors.TransactionError(let error) {
            print(error)
        } catch {
            print(error)
        }
    }
    
}
