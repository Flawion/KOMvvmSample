//
//  WebViewModelTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

@testable import KOMvvmSampleLogic

final class WebViewModelTests: XCTestCase {
    private var appCoordinator: MockedAppCoordinator!
    
    override func setUp() {
        appCoordinator = MockedAppCoordinator()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        appCoordinator = nil
    }
    
    func testInitWithHtml() {
        let html = "<body>test</body>"
        let barTitle = "title"
        
        let webViewModel = WebViewModel(appCoordinator: appCoordinator, barTitle: "title", html: html)
        
        XCTAssertTrue(webViewModel.html?.starts(with: "<header><meta name='viewport'") ?? false)
        XCTAssertNil(webViewModel.url)
        XCTAssertEqual(webViewModel.barTitle, barTitle)
    }
    
    func testInitWithUrl() {
        let url = URL(string: "https://github.com/Flawion")!
        let barTitle = "title"
        
        let webViewModel = WebViewModel(appCoordinator: appCoordinator, barTitle: "title", url: url)
        
        XCTAssertNil(webViewModel.html)
        XCTAssertEqual(webViewModel.url, url)
        XCTAssertEqual(webViewModel.barTitle, barTitle)
    }
    
    func testTryToHandleRelativeUrlFromHtml() {
        let relativeUrl = URL(string: "/non-player-character/3015-967")!
        
        let webViewModel = WebViewModel(appCoordinator: appCoordinator, barTitle: "title", html: "html")
        XCTAssertTrue(webViewModel.tryToHandle(activatedUrl: relativeUrl))
    }
    
    func testHandleAbsoluteUrlFromHtml() {
        let absoluteUrl = URL(string: AppSettings.Api.giantBombAddress + "/non-player-character/3015-967")!
        
        let webViewModel = WebViewModel(appCoordinator: appCoordinator, barTitle: "title", html: "html")
        XCTAssertTrue(webViewModel.tryToHandle(activatedUrl: absoluteUrl))
    }
    
    func testHandleRelativeUrlFromUrlSource() {
        let relativeUrl = URL(string: "/non-player-character/3015-967")!
        
        let webViewModel = WebViewModel(appCoordinator: appCoordinator, barTitle: "title", url: URL(string: AppSettings.Api.giantBombAddress)!)
        XCTAssertTrue(webViewModel.tryToHandle(activatedUrl: relativeUrl))
    }
    
    func testHandleAbsoluteUrlFromUrlSource() {
        let absoluteUrl = URL(string: AppSettings.Api.giantBombAddress + "/non-player-character/3015-967")!
        
        let webViewModel = WebViewModel(appCoordinator: appCoordinator, barTitle: "title", url: URL(string: AppSettings.Api.giantBombAddress)!)
        XCTAssertTrue(webViewModel.tryToHandle(activatedUrl: absoluteUrl))
    }
    
    func testFailureHandleAbsoluteUrlFromUrlSource() {
        let absoluteUrl = URL(string: "https://github.com/Flawion")!
        
        let webViewModel = WebViewModel(appCoordinator: appCoordinator, barTitle: "title", url: absoluteUrl)
        XCTAssertFalse(webViewModel.tryToHandle(activatedUrl: absoluteUrl))
    }
}
