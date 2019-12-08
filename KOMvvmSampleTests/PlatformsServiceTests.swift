//
//  PlatformsServiceTests.swift
//  KOMvvmSampleTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import RxSwift
import RxCocoa

@testable import KOMvvmSample

final class PlatformsServiceTests: XCTestCase {
    private var mockedServices: MockedServices!
    private var platformsService: PlatformsServiceProtocol!
    private var dataStoreService: DataStoreServiceProtocol!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        
        mockedServices = MockedServices()
        initializeTestScene()
    }
    
    private func initializeTestScene() {
        let platformsService: PlatformsServiceProtocol = mockedServices.locator.get(type: .platforms)!
        self.platformsService = platformsService
        //delete platforms cache
        let dataStoreService: DataStoreServiceProtocol = mockedServices.locator.get(type: .dataStore)!
        self.dataStoreService = dataStoreService
        dataStoreService.platforms = nil
        disposeBag = DisposeBag()
    }

    func testDownloadPlatforms() {
        let promisePlatforms = expectation(description: "Platforms returned")
        
        //try to download platforms
        platformsService.refreshPlatformsObser.subscribe(onNext: { platformsAvailable in
            platformsAvailable ? promisePlatforms.fulfill() : XCTAssert(false, "platforms don't available")
        }).disposed(by: disposeBag)
        XCTAssertTrue(platformsService.isDownloading)
        
        //then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
        XCTAssertEqual(platformsService.platforms.count, MockSettings.platformsTotalCount)
        XCTAssertFalse(platformsService.isDownloading)
    }
    
    func testPlatformsCache() {
        testDownloadPlatforms()
        
        //get cached platforms
        guard let platforms = dataStoreService.platforms else {
            XCTAssert(false, "platforms aren't cached")
            return
        }

        //then
        XCTAssertEqual(platforms.count, MockSettings.platformsTotalCount)
        XCTAssertEqual(platformsService.platforms.count, MockSettings.platformsTotalCount)
    }
}
