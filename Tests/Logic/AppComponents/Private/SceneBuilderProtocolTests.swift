//
//  SceneBuilderProtocolTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

@testable import KOMvvmSampleLogic

final class SceneBuilderProtocolTests: XCTestCase {
    private var appCoordinator: TestAppCoordinator!
    private var viewModel: TestViewModel!
    private var sceneBuilder: TestSceneBuilder!
    
    override func setUp() {
        appCoordinator = TestAppCoordinator()
        viewModel = TestViewModel(appCoordinator: appCoordinator)
        sceneBuilder = TestSceneBuilder()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        appCoordinator = nil
        viewModel = nil
        sceneBuilder = nil
    }
    
    func testCreateSceneWithDefaultExtension() {
        XCTAssertTrue(sceneBuilder.createScene(withAppCoordinator: appCoordinator) is TestViewController)
    }
}

private struct TestSceneBuilder: SceneBuilderProtocol {
    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol)) -> UIViewController {
        let viewModel = TestViewModel(appCoordinator: appCoordinator)
        return createScene(withAppCoordinator: appCoordinator, viewModel: viewModel, type: .games)
    }
}

// MARK: - Test classes
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

private final class TestAppCoordinator: BaseAppCoordinator {
    override func registerViewControllers(builder: ScenesViewControllerBuilder) {
        builder.register(viewControllerType: TestViewController.self, forType: .games)
    }
    
    override func setWindowRootViewController() {
    }
}

private final class TestViewModel: BaseViewModel {
}
