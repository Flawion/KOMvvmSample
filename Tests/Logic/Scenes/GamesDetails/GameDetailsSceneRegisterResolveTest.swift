//
//  GameDetailsSceneRegisterResolveTest.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import KOInject

@testable import KOMvvmSampleLogic

final class GameDetailsSceneRegisterResolveTest: XCTestCase {
    
    func test() {
        let appCoordinator = TestAppCoordinator()
        let testGame = GameModel(testModelWithGuid: "1234-1234", name: "name", description: "description")
        
        GameDetailsViewModelRegister().register(register: appCoordinator.iocContainer)
        let viewController = GameDetailsSceneResolver(game: testGame).resolve(withAppCoordinator: appCoordinator, resolver: appCoordinator.iocContainer)
        
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is MockedViewController<GameDetailsViewModelProtocol>)
    }
}

// MARK: - TestAppCoordinator
private class TestAppCoordinator: BaseAppCoordinator {
    let iocContainer = KOIContainer()
    
    override init() {
        super.init(iocContainer: iocContainer)
    }
    
    override func registerViewControllers(register: KOIRegisterProtocol) {
        register.register(forType: GameDetailsViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, game: GameModel) in
            guard let viewModel: GameDetailsViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: game) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
    }
}
