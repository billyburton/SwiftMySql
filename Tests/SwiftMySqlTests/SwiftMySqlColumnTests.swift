import XCTest
import SwiftCMySqlMac
@testable import SwiftMySql

class SwiftMySqlColumnTests: XCTestCase {
    
    let expectedName = "Test Name"
    let expectedIntValue = 10
    let testType = enum_field_types.init(255)
    let expectedType = MySqlFieldTypes.geometry
    let expectedOrdinal = 1
    
    var testColumn: MySqlColumn? = nil
    
    override func setUp() {
        var mySqlField = MYSQL_FIELD()
        mySqlField.name = UnsafeMutablePointer<Int8>(mutating: expectedName)
        mySqlField.length = UInt(expectedIntValue)
        mySqlField.max_length = UInt(expectedIntValue)
        mySqlField.decimals = UInt32(expectedIntValue)
        mySqlField.type = testType
        
        testColumn = MySqlColumn(field: mySqlField, ordinal: expectedOrdinal)
    }
    
    func test_MySqlColumn_name_is_set_correctly() {
        XCTAssertEqual(testColumn?.name, expectedName)
    }
    
    func test_MySqlColumn_length_is_set_correctly() {
        XCTAssertEqual(testColumn?.length, UInt64(expectedIntValue))
    }
    
    func test_MySqlColumn_maxLength_is_set_correctly() {
        XCTAssertEqual(testColumn?.maxLength, UInt64(expectedIntValue))
    }
    
    func test_MySqlColumn_decimals_is_set_correctly() {
        XCTAssertEqual(testColumn?.decimals, Int(expectedIntValue))
    }
    
    func test_MySqlColumn_type_is_set_correctly() {
        XCTAssertEqual(testColumn?.type, expectedType)
    }

}
