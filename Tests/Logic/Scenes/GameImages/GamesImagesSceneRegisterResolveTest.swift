//
//  GamesImagesSceneRegisterResolveTest.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import KOInject

@testable import KOMvvmSampleLogic

final class GamesImagesSceneRegisterResolveTest: XCTestCase {
    
    func test() {
        let appCoordinator = TestAppCoordinator()

        GameImagesViewModelRegister().register(register: appCoordinator.iocContainer)
        let viewController = GameImagesSceneResolver(images: []).resolve(withAppCoordinator: appCoordinator, resolver: appCoordinator.iocContainer)
        
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is MockedViewController<GameImagesViewModelProtocol>)
    }
}

// MARK: - TestAppCoordinator
private class TestAppCoordinator: BaseAppCoordinator {
    let iocContainer = KOIContainer()
    
    override init() {
        super.init(iocContainer: iocContainer)
    }
    
    override func registerViewControllers(register: KOIRegisterProtocol) {
        register.register(forType: GameImagesViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, images: [ImageModel]) in
            guard let viewModel: GameImagesViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: images) else {
                fatalError()
            }
            return MockedViewController(viewModel: viewModel)
        }
    }
}
