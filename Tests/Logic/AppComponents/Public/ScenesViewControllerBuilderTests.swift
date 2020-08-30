//
//  ScenesViewControllerBuilderTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

@testable import KOMvvmSampleLogic

final class ScenesViewControllerBuilderTests: XCTestCase {
    
    private var scenesViewControllerBuilder: ScenesViewControllerBuilder!
    private var appCoordinator: MockedAppCoordinator!
    private var viewModel: TestViewModel!
    
    override func setUp() {
        scenesViewControllerBuilder = ScenesViewControllerBuilder()
        appCoordinator = MockedAppCoordinator()
        viewModel = TestViewModel(appCoordinator: appCoordinator)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        scenesViewControllerBuilder = nil
        appCoordinator = nil
        viewModel = nil
    }
    
    func testRegisterViewController() {
        scenesViewControllerBuilder.register(viewControllerType: TestViewController.self, forType: .games)
        
        guard let viewController = scenesViewControllerBuilder.get(forViewModel: viewModel, type: .games) else {
            XCTAssertTrue(false, "should get viewController")
            return
        }
        
        XCTAssertTrue(viewController is TestViewController)
    }
    
    func testGetNotRegisteredViewController() {
        guard scenesViewControllerBuilder.get(forViewModel: viewModel, type: .games) == nil else {
            XCTAssertTrue(false, "cannot get viewController")
            return
        }
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

private final class TestViewModel: BaseViewModel {
}
