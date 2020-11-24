//
//  MockDataStoreServiceConfigurator.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import KOInject

@testable import KOMvvmSampleLogic

final class MockDataStoreServiceConfigurator {
    private(set) var dataStore: MockDataStoreService!
    
    init(container: KOIContainer) {
        registerService(register: container)
        initializeAfterRegister(resolver: container)
    }
    
    init(register: KOIRegisterProtocol) {
        self.registerService(register: register)
    }
    
    deinit {
        dataStore = nil
    }
    
    private func registerService(register: KOIRegisterProtocol) {
        register.register(forType: DataStoreServiceProtocol.self, scope: .shared, fabric: { _ in
            MockDataStoreService()
        })
    }
    
    func initializeAfterRegister(resolver: KOIResolverProtocol) {
        guard let dataStore: DataStoreServiceProtocol = resolver.resolve(),
              let mockDataStore = dataStore as? MockDataStoreService else {
            fatalError("MockedServices can't get giantBombApiClient service")
        }
        self.dataStore = mockDataStore
    }
}

final class MockDataStoreService: NSObject, DataStoreServiceProtocol {
    private(set) var savePlatformsDate: Date?
    
    var platforms: [PlatformModel]? {
        didSet {
            savePlatformsDate = (platforms != nil ? Date() : nil)
        }
    }
}
