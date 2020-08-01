//
//  GiantBombClientServiceTests.swift
//  KOMvvmSampleLogicTests
//
//  Created by Kuba Ostrowski on 01/08/2020.
//

import XCTest

@testable import KOMvvmSampleLogic

final class GiantBombClientServiceTests: XCTestCase {
    
    private var serviceLocator: ServiceLocator!
    private var giantBombMockClient: GiantBombMockClientService!
    
    override func setUp() {
        serviceLocator = ServiceLocator()
        giantBombMockClient = MockGiantBombMockClientServiceBuilder(serviceLocator: serviceLocator).client
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        serviceLocator = nil
        giantBombMockClient = nil
    }
}
