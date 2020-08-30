//
//  WebViewSceneBuilderTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import XCTest

@testable import KOMvvmSampleLogic

final class WebViewSceneBuilderTests: XCTestCase {
    private var appCoordinator: MockedAppCoordinator!
    
    override func setUp() {
        appCoordinator = MockedAppCoordinator()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        appCoordinator = nil
    }
    
    func testCreateScene() {
        let viewController = WebViewSceneBuilder(barTitle: "title", html: "html").createScene(withAppCoordinator: appCoordinator)
        let viewControllerProtocol = viewController as? ViewControllerProtocol
        XCTAssertNotNil(viewControllerProtocol)
        XCTAssertTrue(viewControllerProtocol?.viewModelInstance is WebViewModel)
    }
}
