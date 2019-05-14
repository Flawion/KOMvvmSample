//
//  MockedServices.swift
//  KOMvvmSampleTests
//
//  Created by Kuba Ostrowski on 14/05/2019.
//

import Foundation

final class MockedServices {
    private let loadDataFromBundleIdentifier: String?
    
    var locator: ServiceLocator!
    var giantBombMockClient: GiantBombMockClientService!
    
    init(forBundle bundle: Bundle) {
        self.loadDataFromBundleIdentifier = bundle.bundleIdentifier
        
        initializeServiceLocator()
        initializeGiantBombMockClient()
    }
    
    private func initializeServiceLocator() {
        locator = ServiceLocator()
        locator.register(withBuilder: GiantBombMockClientServiceBuilder(loadDataFromBundleIdentifier: loadDataFromBundleIdentifier))
        locator.register(withBuilder: DataStoreServiceBuilder())
        locator.register(withBuilder: PlatformsServiceBuilder())
    }
    
    private func initializeGiantBombMockClient() {
        let giantBombClientServiceProtocol: GiantBombClientServiceProtocol = locator.get()!
        giantBombMockClient = (giantBombClientServiceProtocol as! GiantBombMockClientService)
    }

}
