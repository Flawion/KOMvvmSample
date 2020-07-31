//
//  AppSceneTransitionsTests.swift
//  KOMvvmSampleTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

@testable import KOMvvmSampleLogic

final class AppSceneTransitionsTests: XCTestCase {
    
    func testCreatePushTransitionFromBase() {
        XCTAssertTrue(BaseSceneTransition.push(onNavigationController: UINavigationController()) is PushSceneTransition)
    }
    
    func testCreateSetTransitionFromBase() {
        XCTAssertTrue(BaseSceneTransition.set(onNavigationController: UINavigationController()) is SetScenesTransition)
    }
    
    func testCreatePresentTransitionFromBase() {
        XCTAssertTrue(BaseSceneTransition.present(onViewController: UIViewController()) is PresentSceneTransition)
    }
    
    func testPushTransition() {
        let navigationController = UINavigationController(rootViewController: UIViewController())
        
        let transition = PushSceneTransition(onNavigationController: navigationController, animated: false)
        guard let pushedViewController: TestViewController = transition.transition(toScenesViewControllers: [TestViewController()]) as? TestViewController else {
            XCTAssertTrue(false, "Not properly type")
            return
        }
        
        XCTAssertTrue(navigationController.viewControllers.count == 2)
        XCTAssertTrue(navigationController.topViewController is TestViewController)
        XCTAssertTrue(pushedViewController === navigationController.topViewController)
    }
    
    /// should push only first one
    func testPushTransitionMoreThanOne() {
        let navigationController = UINavigationController(rootViewController: UIViewController())
        
        let transition = PushSceneTransition(onNavigationController: navigationController, animated: false)
        guard let pushedViewController = transition.transition(toScenesViewControllers: [TestViewController(), TestViewController2()]) as? TestViewController else {
            XCTAssertTrue(false, "Not properly type")
            return
        }
        
        XCTAssertTrue(navigationController.viewControllers.count == 2)
        XCTAssertTrue(navigationController.topViewController is TestViewController)
        XCTAssertTrue(pushedViewController === navigationController.topViewController)
    }
    
    func testSetTransition() {
        let navigationController = UINavigationController()
        
        let transition = SetScenesTransition(onNavigationController: navigationController, animated: false)
        guard let setedViewControllers = transition.transition(toScenesViewControllers: [TestViewController(), TestViewController2()]) as? [UIViewController] else {
            XCTAssertTrue(false, "Not properly type")
            return
        }
        
        XCTAssertTrue(setedViewControllers.count == 2)
        XCTAssertTrue(navigationController.viewControllers.count == 2)
        for index in 0..<navigationController.viewControllers.count where navigationController.viewControllers[index] !== setedViewControllers[index] {
            XCTAssertTrue(false, "Not properly type")
        }
    }

    func testPresentTransition() {
        let presentingViewController = TestViewController()
        
        let transition = PresentSceneTransition(onViewController: presentingViewController, animated: false)
        guard let presentedViewController = transition.transition(toScenesViewControllers: [TestViewController2()]) as? TestViewController2 else {
            XCTAssertTrue(false, "Not properly type")
            return
        }
        
        XCTAssertTrue(presentingViewController.presentedViewController === presentedViewController)
    }
    
    /// should present only first one
    func testPresentTransitionMoreThanOne() {
        let presentingViewController = TestViewController()
        
        let transition = PresentSceneTransition(onViewController: presentingViewController, animated: false)
        guard let presentedViewController = transition.transition(toScenesViewControllers: [TestViewController(), TestViewController2()]) as? TestViewController else {
            XCTAssertTrue(false, "Not properly type")
            return
        }
        
        XCTAssertTrue(presentingViewController.presentedViewController === presentedViewController)
    }
}

// MARK: - TestViewControllers
private final class TestViewController: UIViewController {
    private var tempViewController: UIViewController?
    
    override var presentedViewController: UIViewController? {
        return tempViewController
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        tempViewController = viewControllerToPresent
    }
}

private final class TestViewController2: UIViewController {
}
