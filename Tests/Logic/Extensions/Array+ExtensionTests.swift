//
//  ArrayExtensionTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

@testable import KOMvvmSampleLogic

final class ArrayExtensionTests: XCTestCase {
    
    func testAppendNotNull() {
        var testTable: [String] = []
        
        testTable.appendIfNotNull("test")
        
        XCTAssertEqual(testTable.count, 1)
    }
    
    func testAppentNull() {
        var testTable: [String] = []
        
        testTable.appendIfNotNull(nil)
        
        XCTAssertEqual(testTable.count, 0)
    }
    
    func testAppendNotNullCollection() {
        var testTable: [String] = ["test0"]
        let testTable2: [String] = ["test1", "test2"]
        
        testTable.append(contentsOf: testTable2)
        
        XCTAssertEqual(testTable.count, testTable2.count + 1)
    }
    
    func testAppendNotNullCollectionToEmpty() {
        var testTable: [String] = []
        let testTable2: [String] = ["test1", "test2"]
        
        testTable.appendIfNotNull(testTable2)
        
        XCTAssertEqual(testTable.count, testTable2.count)
    }
    
    func testAppendNullCollection() {
        var testTable: [String] = []
        let testTable2: [String?] = ["test1", nil]

        testTable.appendIfNotNull(testTable2)
        
        XCTAssertEqual(testTable.count, testTable2.count - 1)
    }
}
