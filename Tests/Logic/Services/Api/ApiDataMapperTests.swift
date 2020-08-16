//
//  ApiDataMapperTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowskion 16/08/2020.
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

@testable import KOMvvmSampleLogic

final class ApiDataMapperTests: XCTestCase {
    
    private var apiDataMapper: ApiDataToJsonMapper!
    private var dateFormatter: DateFormatter!
    
    override func setUp() {
        apiDataMapper = ApiDataToJsonMapper()
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_us_POSIX")
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        apiDataMapper = nil
        dateFormatter = nil
    }
    
    func testParseDate1() {
        let jsonToParse = "{\"date\":\"2009-07-21T11:05:23+0\"}"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let testClass: TestParseClass = try? apiDataMapper.mapTo(data: jsonToParse.data(using: .utf8)!) else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertNotNil(testClass)
        XCTAssertEqual(dateFormatter.string(from: testClass.date), "2009-07-21T11:05:23+0000")
    }
    
    func testParseDate2() {
        let jsonToParse = "{\"date\":\"2009-07-21 11:05:23\"}"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let testClass: TestParseClass = try? apiDataMapper.mapTo(data: jsonToParse.data(using: .utf8)!) else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertNotNil(testClass)
        XCTAssertEqual(dateFormatter.string(from: testClass.date), "2009-07-21 11:05:23")
    }
    
    func testParseDate3() {
        let jsonToParse = "{\"date\":\"2009-07-21\"}"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let testClass: TestParseClass = try? apiDataMapper.mapTo(data: jsonToParse.data(using: .utf8)!) else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertNotNil(testClass)
        XCTAssertEqual(dateFormatter.string(from: testClass.date), "2009-07-21")
    }
    
    func testErrorParseDate() {
        let jsonToParse = "{\"date\":\"21-07-2019\"}"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let _: TestParseClass = try? apiDataMapper.mapTo(data: jsonToParse.data(using: .utf8)!) else {
            return
        }
        
        XCTAssertTrue(false)
    }
}

private class TestParseClass: Codable {
    let date: Date
}
