//
//  ServiceLocatorTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

@testable import KOMvvmSampleLogic

final class ServiceLocatorTests: XCTestCase {
    
    private var serviceLocator: ServiceLocator!
    
    override func setUp() {
        serviceLocator = ServiceLocator()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        serviceLocator = nil
    }
    
    func testRegisterGiantBombClient() {
        serviceLocator.register(withBuilder: GiantBombClientServiceBuilder())
        
        guard let _: GiantBombClientServiceProtocol = serviceLocator.get(type: .giantBombApiClient) else {
            XCTAssertTrue(false, "Service not found")
            return
        }
    }
    
    func testRegisterGiantBombMockClient() {
        serviceLocator.register(withBuilder: GiantBombMockClientServiceBuilder())
        
        guard let _: GiantBombClientServiceProtocol = serviceLocator.get(type: .giantBombApiClient) else {
            XCTAssertTrue(false, "Service not found")
            return
        }
    }
    
    func testRegisterDataStoreService() {
        serviceLocator.register(withBuilder: DataStoreServiceBuilder())
        
        guard let _: DataStoreServiceProtocol = serviceLocator.get(type: .dataStore) else {
            XCTAssertTrue(false, "Service not found")
            return
        }
    }
    
    func testGetNotRegisteredService() {
        guard let _ : DataStoreServiceProtocol = serviceLocator.get(type: .dataStore) else {
            return
        }
        XCTAssertTrue(false, "Service can't be found")
        return
    }
    
    func testGetOnceCreatedService() {
        serviceLocator.register(withBuilder: GiantBombClientServiceBuilder())
        let _: GiantBombClientServiceProtocol? = serviceLocator.get(type: .giantBombApiClient)
        
        guard let _ : GiantBombClientServiceProtocol = serviceLocator.get(type: .giantBombApiClient) else {
            XCTAssertTrue(false, "Service not found")
            return
        }
    }
}
