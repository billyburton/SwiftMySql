//
//  MySqlColumn.swift
//  SwiftMySql
//
//  Created by William Burton on 05/02/2017.
//  Copyright © 2017 William Burton. All rights reserved.
//

import SwiftCMySqlMac
import Foundation

public enum MySqlFieldTypes: Int {
    case    decimal,
            tiny,
            short,
            long,
            float,
            double,
            null,
            timestamp,
            longlong,
            Int24,
            date,
            time,
            datetime,
            year,
            newdate,
            varchar,
            bit,
            timestamp2,
            datetime2,
            time2,
            json = 245,
            newdecimal = 246,
            enumtype = 247,
            set = 248,
            tinyblob = 249,
            mediumblob = 250,
            longblob = 251,
            blob = 252,
            varstring = 253,
            string = 254,
            geometry = 255,
            undefined = -1
}

public struct MySqlColumn {
    public let ordinal: Int
    public let name: String
    public let length: UInt
    public let maxLength: UInt
    public let decimals: UInt32
    public let type: MySqlFieldTypes
    
    var description: String {
        return "\(name), \(type), \(length), \(maxLength), \(decimals)"
    }
    
    init(name: String, length: UInt, maxLength: UInt, decimals: UInt32, type: MySqlFieldTypes, ordinal: Int) {
        self.ordinal = ordinal
        self.name = name
        self.length = length
        self.maxLength = maxLength
        self.decimals = decimals
        self.type = type
    }
}
