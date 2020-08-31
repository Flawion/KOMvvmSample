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
    
    private var allPlatforms: [PlatformModel] {
        guard let response: BaseResponseModel<[PlatformModel]> = jsonModel(mockName: .platforms), let responsePlatforms = response.results,
            let responseMore: BaseResponseModel<[PlatformModel]> = jsonModel(mockName: .moreplatforms), let responseMorePlatforms = responseMore.results else {
                return []
        }
        return responsePlatforms + responseMorePlatforms
    }
    
    override func setUp() {
        appCoordinator = MockedAppCoordinator()
        let mockGiantBombClientService: GiantBombClientServiceProtocol = appCoordinator.mockGiantBombClientServiceConfigurator.client
        let mockDataStoreService: DataStoreServiceProtocol = appCoordinator.mockDataStoreServiceConfigurator.dataStore
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
        let allPlatforms = self.allPlatforms
        XCTAssertFalse(platformsUseCase.platforms.contains(where: { platform in !allPlatforms.contains(where: { $0.id == platform.id }) }))
        XCTAssertFalse(platforms.contains(where: { platform in !allPlatforms.contains(where: { $0.id == platform.id }) }))
    }
    
    func testDownloadPlatformsNotNeeded() {
        platformsUseCase.downloadPlatformsIfNeed()
        XCTAssertEqual(platformsUseCase.dataActionState, .loading)
        try? platformsUseCase.downloadPlatformsIfNeedObservable.toBlocking().first()
        
        platformsUseCase.downloadPlatformsIfNeed()
        XCTAssertEqual(platformsUseCase.dataActionState, .none)
    }
    
    func testReadPlatformsFromCache() {
        let allPlatforms = self.allPlatforms
        appCoordinator.mockDataStoreServiceConfigurator.dataStore.platforms = allPlatforms
        
        let mockGiantBombClientService: GiantBombClientServiceProtocol = appCoordinator.mockGiantBombClientServiceConfigurator.client
        let mockDataStoreService: DataStoreServiceProtocol = appCoordinator.mockDataStoreServiceConfigurator.dataStore
        let platformsUseCase = PlatformsUseCase(giantBombClient: mockGiantBombClientService, dataStore: mockDataStoreService)
        
        XCTAssertEqual(platformsUseCase.dataActionState, .none)
        let platforms = (try? platformsUseCase.platformsDriver.toBlocking().first()) ?? []
        XCTAssertFalse(platformsUseCase.platforms.contains(where: { platform in !allPlatforms.contains(where: { $0.id == platform.id }) }))
        XCTAssertFalse(platforms.contains(where: { platform in !allPlatforms.contains(where: { $0.id == platform.id }) }))
    }
}
