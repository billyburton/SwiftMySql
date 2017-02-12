//
//  MySqlTransaction.swift
//  mysql_ui
//
//  Created by William Burton on 04/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

class MySqlTransaction: MySqlTransactionProtocol {
    
    private enum MySqlTransactionState {
        case Open,
             Committed,
             Rolledback
    }
    
    let connection: MySqlConnectionProtocol
    private var state = MySqlTransactionState.Open
    
    init(connection: MySqlConnectionProtocol) {
        self.connection = connection
        connection.setAutoCommit(false)
    }
    
    func rollback() throws {
        try connection.rollback()
        state = MySqlTransactionState.Rolledback
    }
    
    func commit() throws {
        if state != MySqlTransactionState.Open {
            return
        }
        
        try connection.commit()
        state = MySqlTransactionState.Committed
    }

    deinit {
        do {
            if (state == MySqlTransactionState.Open) {
                try connection.commit()
            }
            
            connection.setAutoCommit(true)
        } catch MySqlErrors.TransactionError(let error) {
            print(error)
        } catch {
            print(error)
        }
    }
    
}
