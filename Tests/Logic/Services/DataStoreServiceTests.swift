//
//  DataStoreServiceTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

import XCTest

@testable import KOMvvmSampleLogic

final class DataStoreServiceTests: XCTestCase {
    
    private var serviceLocator: ServiceLocator!
    
    override func setUp() {
        serviceLocator = ServiceLocator()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        serviceLocator = nil
    }
    
    func testCeateDataService() {
        let serviceLocator = ServiceLocator()
        
        XCTAssertNotNil(DataStoreServiceBuilder().createService(withServiceLocator: serviceLocator) as? DataStoreServiceProtocol)
    }
    
    func testBuilderType() {
        XCTAssertEqual(DataStoreServiceBuilder().type, .dataStore)
    }
}
