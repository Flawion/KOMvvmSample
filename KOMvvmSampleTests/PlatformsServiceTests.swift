//
//  PlatformsServiceTests.swift
//  KOMvvmSampleTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

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
        
        mockedServices = MockedServices(forBundle: Bundle(for: type(of: self)))
        initializeTestScene()
    }
    
    private func initializeTestScene() {
        let platformsService: PlatformsServiceProtocol = mockedServices.locator.get()!
        self.platformsService = platformsService
        //delete platforms cache
        let dataStoreService: DataStoreServiceProtocol = mockedServices.locator.get()!
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
