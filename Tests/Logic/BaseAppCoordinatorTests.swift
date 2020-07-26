//
//  BaseAppCoordinatorTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
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
        let testViewModel = TestViewModel(appCoordinator: appCoordinator)
        
        let testViewController = appCoordinator.getSceneViewController(forViewModel: testViewModel, type: .games)
        
        XCTAssertTrue(testViewController is TestViewController)
    }
    
    func testCreateWindowRootViewController() {
        appCoordinator.initializeScene()
        
        XCTAssertNotNil(appCoordinator.masterViewController)
        XCTAssertTrue(appCoordinator.window?.rootViewController === appCoordinator.masterViewController)
    }
    
    func testTransitionToViewController() {
        appCoordinator.initializeScene()
        
        let pushedViewController = appCoordinator.transition(.push(onNavigationController: appCoordinator.masterViewController, animated: false), scene: TestSceneBuilder2())
        
        XCTAssertTrue(pushedViewController is TestViewController2)
        XCTAssertTrue(appCoordinator.masterViewController?.topViewController is TestViewController2)
        XCTAssertTrue(appCoordinator.masterViewController?.viewControllers.count == 2)
    }
    
    func testTransitionViewControllers() {
        appCoordinator.initializeScene()
        
        guard let setViewControllers = appCoordinator.transition(.set(onNavigationController: appCoordinator.masterViewController, animated: false), scenes: [TestSceneBuilder2(), TestSceneBuilder()]) as? [UIViewController] else {
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
    var masterViewController: UINavigationController?
    
    override func registerViewControllers(builder: ScenesViewControllerBuilder) {
        builder.register(viewControllerType: TestViewController.self, forType: .games)
    }
    
    override func createWindowRootViewController() {
        let mainSceneViewController = createMainSceneViewController()
        masterViewController = UINavigationController(rootViewController: mainSceneViewController)
        window?.rootViewController = masterViewController
    }
}

// MARK: - TestViewControllers
private final class TestViewController: UIViewController, ViewControllerProtocol {
    var viewModelInstance: Any
    
    required init(viewModel: ViewModelProtocol) {
        self.viewModelInstance = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class TestViewController2: UIViewController, ViewControllerProtocol {
    var viewModelInstance: Any
    
    required init(viewModel: ViewModelProtocol) {
        self.viewModelInstance = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - TestViewModel
private final class TestViewModel: BaseViewModel {
}

// MARK: - TestSceneBuilders
private final class TestSceneBuilder: SceneBuilderProtocol {
    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol)) -> UIViewController {
        return TestViewController(viewModel: TestViewModel(appCoordinator: appCoordinator))
    }
}

private final class TestSceneBuilder2: SceneBuilderProtocol {
    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol)) -> UIViewController {
        return TestViewController2(viewModel: TestViewModel(appCoordinator: appCoordinator))
    }
}
