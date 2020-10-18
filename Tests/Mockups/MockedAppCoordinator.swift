//
//  MockedAppCoordinator.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

@testable import KOMvvmSampleLogic

final class MockedAppCoordinator: BaseAppCoordinator {
    var masterViewController: UINavigationController?
    var mockGiantBombClientServiceConfigurator: MockGiantBombClientServiceConfigurator!
    var mockDataStoreServiceConfigurator: MockDataStoreServiceConfigurator!
    
    override func registerServices(locator: ServiceLocator) {
        mockGiantBombClientServiceConfigurator = MockGiantBombClientServiceConfigurator(serviceLocator: locator)
        mockDataStoreServiceConfigurator = MockDataStoreServiceConfigurator(serviceLocator: locator)
    }
    
    override func registerViewControllers(builder: ScenesViewControllerBuilder) {
        builder.register(viewControllerType: MockedViewController.self, forType: .games)
        builder.register(viewControllerType: MockedViewController.self, forType: .gameDetails)
        builder.register(viewControllerType: MockedViewController.self, forType: .gamesFilters)
        builder.register(viewControllerType: MockedViewController.self, forType: .gameImages)
        builder.register(viewControllerType: MockedViewController.self, forType: .imageViewer)
        builder.register(viewControllerType: MockedViewController.self, forType: .web)
    }
    
    override func setWindowRootViewController() {
        let mainSceneViewController = createMainSceneViewController()
        masterViewController = UINavigationController(rootViewController: mainSceneViewController)
        window?.rootViewController = masterViewController
    }
    
    override func openLink(_ url: URL) {
    }
}
