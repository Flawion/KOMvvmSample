//
//  PlatformsUseCaseTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import RxSwift
import RxBlocking
import XCTest

@testable import KOMvvmSampleLogic

final class PlatformsUseCaseTests: XCTestCase {
    private var appCoordinator: MockedAppCoordinator!
    private var platformsUseCase: PlatformsUseCase!
    
    override func setUp() {
        appCoordinator = MockedAppCoordinator()
        let mockGiantBombClientService = appCoordinator.mockGiantBombClientServiceConfigurator.client!
        let mockDataStoreService = appCoordinator.mockDataStoreServiceConfigurator.dataStore!
        platformsUseCase = PlatformsUseCase(giantBombClient: mockGiantBombClientService, dataStore: mockDataStoreService)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        appCoordinator = nil
        platformsUseCase = nil
    }
    
    func testDownloadPlatformsIfNeed() {
        platformsUseCase.downloadPlatformsIfNeed()
        XCTAssertEqual(platformsUseCase.dataActionState, .loading)
        try? platformsUseCase.downloadPlatformsIfNeedObservable.toBlocking().first()
        
        let platforms = (try? platformsUseCase.platformsDriver.toBlocking().first()) ?? []
        XCTAssertEqual(platformsUseCase.dataActionState, .none)
        guard let response: BaseResponseModel<[PlatformModel]> = jsonModel(mockName: .platforms), let responsePlatforms = response.results else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertTrue(platformsUseCase.platforms.contains(where: { platform in !responsePlatforms.contains(where: { $0.id == platform.id }) }))
        XCTAssertTrue(platforms.contains(where: { platform in !responsePlatforms.contains(where: { $0.id == platform.id }) }))
    }
    
    func testDownlaodPlatformsNotNeeded() {
        platformsUseCase.downloadPlatformsIfNeed()
        XCTAssertEqual(platformsUseCase.dataActionState, .loading)
        try? platformsUseCase.downloadPlatformsIfNeedObservable.toBlocking().first()
        
        platformsUseCase.downloadPlatformsIfNeed()
        XCTAssertEqual(platformsUseCase.dataActionState, .none)
    }
}
