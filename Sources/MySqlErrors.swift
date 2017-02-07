//
//  MySqlErrors.swift
//  mysql_ui
//
//  Created by William Burton on 01/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

enum MySqlErrors : Error {
    case InvalidConnection(error: String)
    case CommandError(error: String)
    case ReaderError(error: String)
    case TransactionError(error: String)
}

func GetMySqlError(connection: UnsafeMutablePointer<MYSQL>?) -> String {
    if let error = mysql_error(connection), let str = String(utf8String: UnsafePointer<CChar>(error)) {
        return str
    } else  {
        return "An error occurred in MySQL"
    }
}
