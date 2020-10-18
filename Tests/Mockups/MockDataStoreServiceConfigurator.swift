//
//  MockDataStoreServiceConfigurator.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

@testable import KOMvvmSampleLogic

final class MockDataStoreServiceConfigurator {
    private(set) var dataStore: MockDataStoreService!
    
    init(serviceLocator: ServiceLocator) {
        registerServiceIfNeed(serviceLocator: serviceLocator)
        initializeService(serviceLocator: serviceLocator)
    }
    
    deinit {
        dataStore = nil
    }
    
    private func registerServiceIfNeed(serviceLocator: ServiceLocator) {
        let dataStore: DataStoreServiceProtocol? = serviceLocator.get(type: .dataStore)
        if dataStore == nil {
            serviceLocator.register(withBuilder: MockDataStoreServiceBuilder())
        }
    }
    
    private func initializeService(serviceLocator: ServiceLocator) {
        guard let dataStore: MockDataStoreService = serviceLocator.get(type: .dataStore) else {
            fatalError("MockedServices can't get giantBombApiClient service")
        }
        self.dataStore = dataStore
    }
}

final class MockDataStoreServiceBuilder: ServiceBuilderProtocol {
    var type: ServiceTypes {
        return .dataStore
    }
    
    func createService(withServiceLocator serviceLocator: ServiceLocator) -> Any {
        return MockDataStoreService()
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
