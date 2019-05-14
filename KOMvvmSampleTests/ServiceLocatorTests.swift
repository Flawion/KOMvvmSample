//
//  ServiceLocatorTests.swift
//  KOMvvmSampleTests
//
//  Created by Kuba Ostrowski on 14/05/2019.
//

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
        
        guard let _: GiantBombClientServiceProtocol = serviceLocator.get() else {
            XCTAssertTrue(false, "Service not founded")
            return
        }
    }
    
    func testRegisterGiantBombMockClient() {
        serviceLocator.register(withBuilder: GiantBombMockClientServiceBuilder(loadDataFromBundleIdentifier: nil))
        
        guard let _: GiantBombClientServiceProtocol = serviceLocator.get() else {
            XCTAssertTrue(false, "Service not founded")
            return
        }
    }
    
    func testRegisterDataStoreService() {
        serviceLocator.register(withBuilder: DataStoreServiceBuilder())
        
        guard let _: DataStoreServiceProtocol = serviceLocator.get() else {
            XCTAssertTrue(false, "Service not founded")
            return
        }
    }
    
    func testRegisterPlatformsService() {
        serviceLocator.register(withBuilder: GiantBombClientServiceBuilder())
        serviceLocator.register(withBuilder: DataStoreServiceBuilder())
        serviceLocator.register(withBuilder: PlatformsServiceBuilder())
        
        guard let _: PlatformsServiceProtocol = serviceLocator.get() else {
            XCTAssertTrue(false, "Service not founded")
            return
        }
    }
}
