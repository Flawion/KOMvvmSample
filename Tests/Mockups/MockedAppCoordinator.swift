//
//  MockedAppCoordinator.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOInject

@testable import KOMvvmSampleLogic

final class MockedAppCoordinator: BaseAppCoordinator {
    private let iocContainer: KOIContainer = KOIContainer()
    var masterViewController: UINavigationController?
    var mockGiantBombClientServiceConfigurator: MockGiantBombClientServiceConfigurator!
    var mockDataStoreServiceConfigurator: MockDataStoreServiceConfigurator!
    
    override init() {
        super.init(iocContainer: iocContainer)
    }
    
    override func registerServices(register: KOIRegisterProtocol) {
        mockGiantBombClientServiceConfigurator = MockGiantBombClientServiceConfigurator(register: register)
        mockGiantBombClientServiceConfigurator.initializeAfterRegister(resolver: iocContainer)
        mockDataStoreServiceConfigurator = MockDataStoreServiceConfigurator(register: register)
        mockDataStoreServiceConfigurator.initializeAfterRegister(resolver: iocContainer)
    }
    
    override func registerViewControllers(register: KOIRegisterProtocol) {
        register.register(forType: GamesViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol) in
            guard let viewModel: GamesViewModelProtocol = resolver.resolve(arg1: appCoordinator) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
        
        register.register(forType: GameDetailsViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, game: GameModel) in
            guard let viewModel: GameDetailsViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: game) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
        
        register.register(forType: GamesFiltersViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, currentFilters: [GamesFilters: String]) in
            guard let viewModel: GamesFiltersViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: currentFilters) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
        
        register.register(forType: GameImagesViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, images: [ImageModel]) in
            guard let viewModel: GameImagesViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: images) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
        
        register.register(forType: WebViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, barTitle: String, html: String) in
            guard let viewModel: WebViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: barTitle, arg3: html) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
        
        register.register(forType: WebViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, barTitle: String, url: URL) in
            guard let viewModel: WebViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: barTitle, arg3: url) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
        
        register.register(forType: ImageViewerViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, image: ImageModel) in
            guard let viewModel: ImageViewerViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: image) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
    }
    
    override func setWindowRootViewController() {
        let mainSceneViewController = createMainSceneViewController()
        masterViewController = UINavigationController(rootViewController: mainSceneViewController)
        window?.rootViewController = masterViewController
    }
    
    override func createMainSceneViewController() -> UIViewController {
        return UIViewController()
    }
    
    override func openLink(_ url: URL) {
    }
}
