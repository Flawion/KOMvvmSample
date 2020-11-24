//
//  GameDetailsUseCaseTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import KOInject
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import KOMvvmSampleLogic

final class GameDetailsUseCaseTests: XCTestCase {
    private var container: KOIContainer!
    private var mockGiantBombClientServiceConfigurator: MockGiantBombClientServiceConfigurator!
    private var testGame: GameModel!
    private var giantBombMockClient: GiantBombMockClientService!
    private var gameDetailsUseCase: GameDetailsUseCase!
    
    override func setUp() {
        container = KOIContainer()
        mockGiantBombClientServiceConfigurator = MockGiantBombClientServiceConfigurator(container: container)
        let gameDetailsGuid = mockGiantBombClientServiceConfigurator.gameDetailsGuid
        let gameDetailsName = mockGiantBombClientServiceConfigurator.gameDetailsName
        testGame = GameModel(testModelWithGuid: gameDetailsGuid, name: gameDetailsName, description: "test")
        giantBombMockClient = mockGiantBombClientServiceConfigurator.client
        gameDetailsUseCase = GameDetailsUseCase(game: testGame, giantBombClient: giantBombMockClient)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        container = nil
        mockGiantBombClientServiceConfigurator = nil
        testGame = nil
        giantBombMockClient = nil
        gameDetailsUseCase = nil
    }
    
    func testGameOnInit() {
        guard let game = try? gameDetailsUseCase.gameDriver.toBlocking().first() else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(game.name, testGame.name)
        XCTAssertEqual(game.guid, testGame.guid)
    }
    
    func testGenerateGameDetailItemsOnInit() {
        let gameDetailsItems = (try? gameDetailsUseCase.gameDetailsItemsDriver.toBlocking().first()) ?? []
        
        XCTAssertEqual(gameDetailsItems.count, 1)
        XCTAssertNotNil(gameDetailsItems.first(where: { $0.item == .overview }))
        XCTAssertEqual(gameDetailsUseCase.gameDetailsItems.count, 1)
        XCTAssertNotNil(gameDetailsUseCase.gameDetailsItems.first(where: { $0.item == .overview }))
    }
    
    func testGenerateGameDetailItemsNilDescOnInit() {
        let game = GameModel(testModelWithGuid: testGame.guid, name: testGame.name, description: nil)
        let gameDetailsUseCase = GameDetailsUseCase(game: game, giantBombClient: giantBombMockClient)
        let gameDetailsItems = (try? gameDetailsUseCase.gameDetailsItemsDriver.toBlocking().first()) ?? []
               
        XCTAssertEqual(gameDetailsItems.count, 0)
        XCTAssertEqual(gameDetailsUseCase.gameDetailsItems.count, 0)
    }
    
    func testDownloadGameDetails() {
        guard let response: BaseResponseModel<GameDetailsModel> = jsonModel(mockName: .gamedetails), let expectedGameDetails = response.results else {
            XCTAssertTrue(false)
            return
        }
        
        gameDetailsUseCase.downloadIfNeed()
        XCTAssertEqual(gameDetailsUseCase.dataActionState, .loading)
        wait(timeout: 0.1)
        
        XCTAssertEqual(gameDetailsUseCase.dataActionState, .none)
        guard let gameDetails = try? gameDetailsUseCase.gameDetailsDriver.toBlocking().first() else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(gameDetailsUseCase.gameDetails?.name, expectedGameDetails.name)
        XCTAssertEqual(gameDetailsUseCase.gameDetails?.guid, expectedGameDetails.guid)
        XCTAssertEqual(gameDetails?.name, expectedGameDetails.name)
        XCTAssertEqual(gameDetails?.guid, expectedGameDetails.guid)
        if gameDetails?.reviews != nil {
            XCTAssertNotNil(gameDetailsUseCase.gameDetailsItems.contains(where: { $0.item == .reviews }))
        }
        if gameDetails?.videos != nil {
            XCTAssertNotNil(gameDetailsUseCase.gameDetailsItems.contains(where: { $0.item == .videos }))
        }
        if gameDetails?.images != nil {
            XCTAssertNotNil(gameDetailsUseCase.gameDetailsItems.contains(where: { $0.item == .images }))
        }
    }
    
    func testDownloadGameDetailsError() {
        giantBombMockClient.mockSimulateFail = true
        gameDetailsUseCase.downloadIfNeed()
        XCTAssertEqual(gameDetailsUseCase.dataActionState, .loading)
        wait(timeout: 0.1)
        
        giantBombMockClient.mockSimulateFail = false
        XCTAssertEqual(gameDetailsUseCase.dataActionState, .error)
    }
    
    func testDownloadGameDetailsNotNeeded() {
        gameDetailsUseCase.downloadIfNeed()
        wait(timeout: 0.1)
        
        gameDetailsUseCase.downloadIfNeed()
        XCTAssertEqual(gameDetailsUseCase.dataActionState, .none)
    }
    
    func testGameDetailIndexForItem() {
        gameDetailsUseCase.downloadIfNeed()
        wait(timeout: 0.1)
        
        XCTAssertEqual(gameDetailsUseCase.gameDetailsItem(forIndex: 0)?.item, .overview)
        XCTAssertEqual(gameDetailsUseCase.gameDetailsItem(forIndex: gameDetailsUseCase.gameDetailsItems.count  - 1)?.item, gameDetailsUseCase.gameDetailsItems.last?.item)
        XCTAssertNil(gameDetailsUseCase.gameDetailsItem(forIndex: gameDetailsUseCase.gameDetailsItems.count + 1))
    }
}
