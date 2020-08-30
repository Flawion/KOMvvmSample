//
//  GameDetailsViewModelTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import RxSwift
import RxCocoa
import RxBlocking

@testable import KOMvvmSampleLogic

final class GameDetailsViewModelTests: XCTestCase {
    private var appCoordinator: MockedAppCoordinator!
    private var giantBombMockClient: GiantBombMockClientService!
    private var testGame: GameModel!
    private var gameDetailsViewModel: GameDetailsViewModel!
    
    override func setUp() {
        appCoordinator = MockedAppCoordinator()
        let mockGiantBombClientServiceConfigurator = appCoordinator.mockGiantBombClientServiceConfigurator!
        giantBombMockClient = mockGiantBombClientServiceConfigurator.client!
        let gameDetailsGuid = mockGiantBombClientServiceConfigurator.gameDetailsGuid
        let gameDetailsName = mockGiantBombClientServiceConfigurator.gameDetailsName
        testGame = GameModel(testModelWithGuid: gameDetailsGuid, name: gameDetailsName, description: "test")
        let gameDetailsUseCase = GameDetailsUseCase(game: testGame, giantBombClient: giantBombMockClient)
        gameDetailsViewModel = GameDetailsViewModel(appCoordinator: appCoordinator, gameDetailsUseCase: gameDetailsUseCase)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        appCoordinator = nil
        testGame = nil
        gameDetailsViewModel = nil
    }

    func testGameOnInit() {
        guard let game = try? gameDetailsViewModel.gameDriver.toBlocking().first() else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(game.name, testGame.name)
        XCTAssertEqual(game.guid, testGame.guid)
        XCTAssertEqual(gameDetailsViewModel.game.name, testGame.name)
        XCTAssertEqual(gameDetailsViewModel.game.guid, testGame.guid)
    }
    
    func testDownloadGameDetails() {
        guard let response: BaseResponseModel<GameDetailsModel> = jsonModel(mockName: .gamedetails), let expectedGameDetails = response.results else {
            XCTAssertTrue(false)
            return
        }
        
        gameDetailsViewModel.downloadGameDetailsIfNeed()
        XCTAssertEqual(gameDetailsViewModel.dataActionState, .loading)
        wait(timeout: 0.1)
        
        XCTAssertEqual(gameDetailsViewModel.dataActionState, .none)
        guard let gameDetails = try? gameDetailsViewModel.gameDetailsDriver.toBlocking().first() else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(gameDetailsViewModel.gameDetails?.name, expectedGameDetails.name)
        XCTAssertEqual(gameDetailsViewModel.gameDetails?.guid, expectedGameDetails.guid)
        XCTAssertEqual(gameDetails?.name, expectedGameDetails.name)
        XCTAssertEqual(gameDetails?.guid, expectedGameDetails.guid)
        if gameDetails?.reviews != nil {
            XCTAssertNotNil(gameDetailsViewModel.gameDetailsItems.contains(where: { $0.item == .reviews }))
        }
        if gameDetails?.videos != nil {
            XCTAssertNotNil(gameDetailsViewModel.gameDetailsItems.contains(where: { $0.item == .videos }))
        }
        if gameDetails?.images != nil {
            XCTAssertNotNil(gameDetailsViewModel.gameDetailsItems.contains(where: { $0.item == .images }))
        }
    }
    
    func testGameDetailIndexForItem() {
        gameDetailsViewModel.downloadGameDetailsIfNeed()
        wait(timeout: 0.1)
        
        XCTAssertEqual(gameDetailsViewModel.gameDetailsItem(forIndex: 0)?.item, .overview)
        XCTAssertEqual(gameDetailsViewModel.gameDetailsItem(forIndex: gameDetailsViewModel.gameDetailsItems.count  - 1)?.item, gameDetailsViewModel.gameDetailsItems.last?.item)
        XCTAssertNil(gameDetailsViewModel.gameDetailsItem(forIndex: gameDetailsViewModel.gameDetailsItems.count + 1))
    }
}
