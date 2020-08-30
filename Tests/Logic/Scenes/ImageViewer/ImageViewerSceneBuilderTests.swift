//
//  ImageViewerSceneBuilderTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import XCTest

@testable import KOMvvmSampleLogic

final class ImageViewerSceneBuilderTests: XCTestCase {
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
        let imageModel = ImageModel(iconUrl: nil, mediumUrl: nil, screenUrl: nil, screenLargeUrl: nil, smallUrl: nil, superUrl: nil, thumbUrl: nil, tinyUrl: nil, original: nil, imageTags: nil)
        let viewController = ImageViewerSceneBuilder(image: imageModel).createScene(withAppCoordinator: appCoordinator)
        let viewControllerProtocol = viewController as? ViewControllerProtocol
        XCTAssertNotNil(viewControllerProtocol)
        XCTAssertTrue(viewControllerProtocol?.viewModelInstance is ImageViewerViewModel)
    }
}
