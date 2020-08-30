//
//  GameImagesSceneBuilderTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import XCTest

@testable import KOMvvmSampleLogic

final class GameImagesSceneBuilderTests: XCTestCase {
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
        let images: [ImageModel] = []
        let viewController = GameImagesSceneBuilder(images: images).createScene(withAppCoordinator: appCoordinator)
        let viewControllerProtocol = viewController as? ViewControllerProtocol
        XCTAssertNotNil(viewControllerProtocol)
        XCTAssertTrue(viewControllerProtocol?.viewModelInstance is GameImagesViewModel)
    }
}
