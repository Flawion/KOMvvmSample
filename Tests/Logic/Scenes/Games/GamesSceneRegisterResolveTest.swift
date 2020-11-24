//
//  GamesViewModelRegisterTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import KOInject

@testable import KOMvvmSampleLogic

final class GamesSceneRegisterResolveTest: XCTestCase {
    
    func test() {
        let appCoordinator = TestAppCoordinator()
        
        GamesViewModelRegister().register(register: appCoordinator.iocContainer)
        let viewController = GamesSceneResolver().resolve(withAppCoordinator: appCoordinator, resolver: appCoordinator.iocContainer)
        
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is MockedViewController<GamesViewModelProtocol>)
    }
}

// MARK: - TestAppCoordinator
private class TestAppCoordinator: BaseAppCoordinator {
    let iocContainer = KOIContainer()
    
    override init() {
        super.init(iocContainer: iocContainer)
    }
    
    override func registerViewControllers(register: KOIRegisterProtocol) {
        register.register(forType: GamesViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol) in
            guard let viewModel: GamesViewModelProtocol = resolver.resolve(arg1: appCoordinator) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
    }
}
