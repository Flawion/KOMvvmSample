//
//  ServiceLocatorTests.swift
//  KOMvvmSampleTests
//
///  Copyright (c) 2019 Kuba Ostrowski
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
