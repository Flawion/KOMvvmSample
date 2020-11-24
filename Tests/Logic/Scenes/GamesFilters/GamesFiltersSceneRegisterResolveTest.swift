//
//  GamesFiltersSceneRegisterResolveTest.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import KOInject

@testable import KOMvvmSampleLogic

final class GamesFiltersSceneRegisterResolveTest: XCTestCase {
    
    func test() {
        let appCoordinator = TestAppCoordinator()
        
        GamesFiltersViewModelRegister().register(register: appCoordinator.iocContainer)
        let viewController = GamesFiltersSceneResolver(currentFilters: [:]).resolve(withAppCoordinator: appCoordinator, resolver: appCoordinator.iocContainer)
        
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is MockedViewController<GamesFiltersViewModelProtocol>)
    }
}

// MARK: - TestAppCoordinator
private class TestAppCoordinator: BaseAppCoordinator {
    let iocContainer = KOIContainer()
    
    override init() {
        super.init(iocContainer: iocContainer)
    }
    
    override func registerViewControllers(register: KOIRegisterProtocol) {
        register.register(forType: GamesFiltersViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, currentFilters: [GamesFilters: String]) in
            guard let viewModel: GamesFiltersViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: currentFilters) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
    }
}
