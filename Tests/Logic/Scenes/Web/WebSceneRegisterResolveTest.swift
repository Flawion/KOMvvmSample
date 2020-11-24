//
//  WebSceneRegisterResolveTest.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import KOInject

@testable import KOMvvmSampleLogic

final class WebSceneRegisterResolveTest: XCTestCase {
    
    func testWithURL() {
        let appCoordinator = TestAppCoordinator()

        WebViewModelRegister().register(register: appCoordinator.iocContainer)
        let viewController = WebSceneResolver(barTitle: "test title", url: URL(string: "google.pl")!).resolve(withAppCoordinator: appCoordinator, resolver: appCoordinator.iocContainer)
        
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is MockedViewController<WebViewModelProtocol>)
    }
    
    func testWithHtml() {
        let appCoordinator = TestAppCoordinator()

        WebViewModelRegister().register(register: appCoordinator.iocContainer)
        let viewController = WebSceneResolver(barTitle: "test title", html: "<p>test</p>").resolve(withAppCoordinator: appCoordinator, resolver: appCoordinator.iocContainer)
        
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is MockedViewController<WebViewModelProtocol>)
    }
}

// MARK: - TestAppCoordinator
private class TestAppCoordinator: BaseAppCoordinator {
    let iocContainer = KOIContainer()
    
    override init() {
        super.init(iocContainer: iocContainer)
    }
    
    override func registerViewControllers(register: KOIRegisterProtocol) {
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
    }
}
