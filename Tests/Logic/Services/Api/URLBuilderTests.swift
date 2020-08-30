//
//  URLBuilderTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

@testable import KOMvvmSampleLogic

final class URLBuilderTests: XCTestCase {
    
    private var urlBuilder: URLBuilder!
    
    override func setUp() {
        urlBuilder = URLBuilder(apiAddress: "http://apiAddress", apiVersion: "v2.0")
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        urlBuilder = nil
    }
    
    func testBuild() {
        guard let url = urlBuilder.build(components: ["path1", "path2", "path3", "path4"]) else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(url.absoluteString, "http://apiAddress/v2.0/path1/path2/path3/path4")
    }
    
    func testBuildWithDifferentUrl() {
        guard let url = urlBuilder.build(components: ["path1", "path2", "path3", "path4"], apiAddress: "https://differentAddress/") else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(url.absoluteString, "https://differentAddress/v2.0/path1/path2/path3/path4")
    }
    
    func testBuildWithVersionUrl() {
        guard let url = urlBuilder.build(components: ["path1", "path2", "path3", "path4"], apiVersion: "3.0") else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(url.absoluteString, "http://apiAddress/3.0/path1/path2/path3/path4")
    }
    
    func testBuildWithEmptyUrlAddress() {
        let urlBuilder = URLBuilder(apiAddress: "", apiVersion: nil)
        let url = urlBuilder.build(components: ["path1"])
        XCTAssertNil(url)
    }
}
