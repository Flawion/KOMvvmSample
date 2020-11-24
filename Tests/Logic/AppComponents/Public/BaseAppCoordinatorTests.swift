//
//  BaseAppCoordinatorTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import KOInject
import UIKit

@testable import KOMvvmSampleLogic

final class BaseAppCoordinatorTests: XCTestCase {
    private var appCoordinator: TestAppCoordinator!
    
    override func setUp() {
        appCoordinator = TestAppCoordinator()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        appCoordinator = nil
    }
    
    func testRegisterViewControllerRuns() {
        appCoordinator.initializeScene()
        
        let testViewController: TestViewControllerProtocol? = appCoordinator.resolve()
        
        XCTAssertTrue(testViewController is TestViewController)
    }
    
    func testCreateWindowRootViewController() {
        appCoordinator.initializeScene()
        
        XCTAssertNotNil(appCoordinator.masterViewController)
        XCTAssertTrue(appCoordinator.window?.rootViewController === appCoordinator.masterViewController)
    }
    
    func testTransitionToViewController() {
        appCoordinator.initializeScene()
        
        let pushedViewController = appCoordinator.transition(.push(onNavigationController: appCoordinator.masterViewController!, animated: false), toScene: TestSceneResolver2())
        
        XCTAssertTrue(pushedViewController is TestViewController2)
        XCTAssertTrue(appCoordinator.masterViewController?.topViewController is TestViewController2)
        XCTAssertTrue(appCoordinator.masterViewController?.viewControllers.count == 2)
    }
    
    func testTransitionViewControllers() {
        appCoordinator.initializeScene()
        
        guard let setViewControllers = appCoordinator.transition(.set(onNavigationController: appCoordinator.masterViewController!, animated: false), toScenes: [TestSceneResolver2(), TestSceneResolver()]) as? [UIViewController] else {
            XCTAssertTrue(false, "did not return viewControllers")
            return
        }
        
        XCTAssertTrue(setViewControllers.count == 2)
        XCTAssertTrue(setViewControllers[0] is TestViewController2)
        XCTAssertTrue(setViewControllers[1] is TestViewController)
        XCTAssertTrue(appCoordinator.masterViewController?.topViewController is TestViewController)
        XCTAssertTrue(appCoordinator.masterViewController?.viewControllers.count == 2)
    }
    
    func testStartValueOfBlockUserInteraction() {
        appCoordinator.initializeScene()
        
        XCTAssertEqual(appCoordinator.isUserInteractionEnabled, appCoordinator.window?.isUserInteractionEnabled)
        XCTAssertTrue(appCoordinator.isUserInteractionEnabled)
    }
    
    func testChangingBlockUserInteraction() {
        appCoordinator.initializeScene()
        
        appCoordinator.isUserInteractionEnabled = false
        
        XCTAssertTrue(appCoordinator.window?.isUserInteractionEnabled == false)
    }
}

// MARK: - TestAppCoordinator
private final class TestAppCoordinator: BaseAppCoordinator {
    private let iocContainer: KOIContainer = KOIContainer()
    var masterViewController: UINavigationController?
    
    override init() {
        super.init(iocContainer: iocContainer)
    }
    
    override func registerViewControllers(register: KOIRegisterProtocol) {
        register.register(forType: ViewModelProtocol.self, scope: .separate) { [weak self] _ -> ViewModelProtocol in
            guard let self = self else {
                fatalError()
            }
            return TestViewModel(appCoordinator: self)
        }
        
        register.register(forType: TestViewControllerProtocol.self, scope: .separate) { container -> TestViewControllerProtocol in
            guard let viewModel: ViewModelProtocol = container.resolve() else {
                fatalError()
            }
            return TestViewController(viewModel: viewModel)
        }
        
        register.register(forType: TestViewControllerProtocol2.self, scope: .separate) { container -> TestViewControllerProtocol2 in
            guard let viewModel: ViewModelProtocol = container.resolve() else {
                fatalError()
            }
            return TestViewController2(viewModel: viewModel)
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
    
    func resolve<Type>() -> Type? {
        return iocContainer.resolve()
    }
}

// MARK: - TestViewControllers
private protocol TestViewControllerProtocol: ViewControllerProtocol {
    var viewModel: ViewModelProtocol { get }
    
    init(viewModel: ViewModelProtocol)
}

private final class TestViewController: UIViewController, TestViewControllerProtocol {
    let viewModel: ViewModelProtocol
    
    required init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class TestSceneResolver: SceneResolverProtocol {
    func resolve(withAppCoordinator appCoordinator: AppCoordinatorProtocol, resolver: KOIResolverProtocol) -> UIViewController {
        let testViewController: TestViewControllerProtocol = resolver.resolve()!
        return testViewController
    }
}

private protocol TestViewControllerProtocol2: ViewControllerProtocol {
    var viewModel: ViewModelProtocol { get }
    
    init(viewModel: ViewModelProtocol)
}

private final class TestViewController2: UIViewController, TestViewControllerProtocol2 {
    let viewModel: ViewModelProtocol
    
    required init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class TestSceneResolver2: SceneResolverProtocol {
    func resolve(withAppCoordinator appCoordinator: AppCoordinatorProtocol, resolver: KOIResolverProtocol) -> UIViewController {
        let testViewController: TestViewControllerProtocol2 = resolver.resolve()!
        return testViewController
    }
}

// MARK: - TestViewModel
private final class TestViewModel: BaseViewModel {
}
