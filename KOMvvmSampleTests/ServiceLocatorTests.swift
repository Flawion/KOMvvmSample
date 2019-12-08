//
//  ServiceLocatorTests.swift
//  KOMvvmSampleTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

@testable import KOMvvmSample

final class ServiceLocatorTests: XCTestCase {
    
    private var serviceLocator: ServiceLocator!
    
    override func setUp() {
        super.setUp()
    
        serviceLocator = ServiceLocator()
    }
    
    func testRegisterGiantBombClient() {
        serviceLocator.register(withBuilder: GiantBombClientServiceBuilder())
        
        guard let _: GiantBombClientServiceProtocol = serviceLocator.get(type: .giantBombApiClient) else {
            XCTAssertTrue(false, "Service not founded")
            return
        }
    }
    
    func testRegisterGiantBombMockClient() {
        serviceLocator.register(withBuilder: GiantBombMockClientServiceBuilder())
        
        guard let _: GiantBombClientServiceProtocol = serviceLocator.get(type: .giantBombApiClient) else {
            XCTAssertTrue(false, "Service not founded")
            return
        }
    }
    
    func testRegisterDataStoreService() {
        serviceLocator.register(withBuilder: DataStoreServiceBuilder())
        
        guard let _: DataStoreServiceProtocol = serviceLocator.get(type: .dataStore) else {
            XCTAssertTrue(false, "Service not founded")
            return
        }
    }
    
    func testRegisterPlatformsService() {
        serviceLocator.register(withBuilder: GiantBombClientServiceBuilder())
        serviceLocator.register(withBuilder: DataStoreServiceBuilder())
        serviceLocator.register(withBuilder: PlatformsServiceBuilder())
        
        guard let _: PlatformsServiceProtocol = serviceLocator.get(type: .platforms) else {
            XCTAssertTrue(false, "Service not founded")
            return
        }
    }
}
