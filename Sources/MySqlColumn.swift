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

struct MySqlColumn {
    public let ordinal: Int
    public let name: String
    public let length: UInt64
    public let maxLength: UInt64
    public let decimals: Int
    public let type: MySqlFieldTypes
    
    var description: String {
        return "\(name), \(type), \(length), \(maxLength), \(decimals)"
    }
    
    public init(field: MYSQL_FIELD, ordinal: Int) {
        self.ordinal = ordinal
        
        if let name = String(utf8String: UnsafePointer<CChar>(field.name)) {
            self.name = name
        } else {
            self.name = ""
        }
        
        self.length = UInt64(field.length)
        self.maxLength = UInt64(field.max_length)
        self.decimals = Int(field.decimals)
        
        if let type = MySqlFieldTypes(rawValue: Int(field.type.rawValue)) {
            self.type = type
        } else {
            self.type = MySqlFieldTypes.undefined
        }
    }
}
