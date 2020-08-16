//
//  SearchGamesUseCaseTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowskion 16/08/2020.
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import KOMvvmSampleLogic

final class SearchGamesUseCaseTests: XCTestCase {
    private var serviceLocator: ServiceLocator!
    private var mockGiantBombMockClientServiceBuilder: MockGiantBombMockClientServiceBuilder!
    private var giantBombMockClient: GiantBombMockClientService!
    private var searchGamesUseCase: SearchGamesUseCase!
    
    override func setUp() {
        serviceLocator = ServiceLocator()
        mockGiantBombMockClientServiceBuilder = MockGiantBombMockClientServiceBuilder(serviceLocator: serviceLocator)
        giantBombMockClient = MockGiantBombMockClientServiceBuilder(serviceLocator: serviceLocator).client
        searchGamesUseCase = SearchGamesUseCase(giantBombClient: giantBombMockClient)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        serviceLocator = nil
        mockGiantBombMockClientServiceBuilder = nil
        giantBombMockClient = nil
        searchGamesUseCase = nil
    }
    
    func testSearchIfNeed() {
        let gamesFromDriverBefore = try? searchGamesUseCase.gamesDriver.toBlocking().first()
        XCTAssertEqual(gamesFromDriverBefore?.count ?? 0, 0)
        XCTAssertEqual(searchGamesUseCase.games.count, 0)
        XCTAssertEqual(searchGamesUseCase.dataActionState, DataActionStates.none)
        
        searchGamesUseCase.searchIfNeed()
        XCTAssertEqual(searchGamesUseCase.dataActionState, DataActionStates.loading)
        wait(timeout: 0.1)
        
        let gamesFromDriver = try? searchGamesUseCase.gamesDriver.toBlocking().first()
        XCTAssertEqual(gamesFromDriver?.count ?? 0, AppSettings.Games.limitPerRequest)
        XCTAssertEqual(searchGamesUseCase.games.count, AppSettings.Games.limitPerRequest)
        XCTAssertTrue(searchGamesUseCase.canDownloadMoreResults)
        XCTAssertEqual(searchGamesUseCase.dataActionState, DataActionStates.none)
    }
    
    func testSearchIfNotNeed() {
        searchGamesUseCase.searchIfNeed()
        wait(timeout: 0.1)
        
        searchGamesUseCase.searchIfNeed()
        wait(timeout: 0.1)
        
        let gamesFromDriver = try? searchGamesUseCase.gamesDriver.toBlocking().first()
        XCTAssertEqual(gamesFromDriver?.count ?? 0, AppSettings.Games.limitPerRequest)
        XCTAssertEqual(searchGamesUseCase.games.count, AppSettings.Games.limitPerRequest)
        XCTAssertTrue(searchGamesUseCase.canDownloadMoreResults)
        XCTAssertEqual(searchGamesUseCase.dataActionState, DataActionStates.none)
    }
    
    func testSearchIfNeedWithError() {
        giantBombMockClient.mockSimulateFail = true
        
        searchGamesUseCase.searchIfNeed()
        XCTAssertEqual(searchGamesUseCase.dataActionState, DataActionStates.loading)
        wait(timeout: 0.1)
        giantBombMockClient.mockSimulateFail = false
        
        XCTAssertEqual(searchGamesUseCase.dataActionState, DataActionStates.error)
        let gamesFromDriver = try? searchGamesUseCase.gamesDriver.toBlocking().first()
        XCTAssertEqual(gamesFromDriver?.count ?? 0, 0)
        XCTAssertEqual(searchGamesUseCase.games.count, 0)
        XCTAssertFalse(searchGamesUseCase.canDownloadMoreResults)
    }
    
    func testSearchMore() {
        searchGamesUseCase.searchIfNeed()
        wait(timeout: 0.1)
        
        searchGamesUseCase.searchMore()
        XCTAssertEqual(searchGamesUseCase.dataActionState, DataActionStates.loadingMore)
        wait(timeout: 0.1)
       
        let gamesFromDriver = try? searchGamesUseCase.gamesDriver.toBlocking().first()
        XCTAssertEqual(gamesFromDriver?.count ?? 0, AppSettings.Games.limitPerRequest * 2)
        XCTAssertEqual(searchGamesUseCase.games.count, AppSettings.Games.limitPerRequest * 2)
        XCTAssertTrue(searchGamesUseCase.canDownloadMoreResults)
        XCTAssertEqual(searchGamesUseCase.dataActionState, DataActionStates.none)
    }
    
    func testSearchMoreWithError() {
        searchGamesUseCase.searchIfNeed()
        wait(timeout: 0.1)
        var isErrorRaised: Bool = false
        let disposeBag = DisposeBag()
        
        giantBombMockClient.mockSimulateFail = true
        searchGamesUseCase.searchMore()
        XCTAssertEqual(searchGamesUseCase.dataActionState, DataActionStates.loadingMore)
        searchGamesUseCase.raiseErrorDriver.drive(onNext: { _ in
            isErrorRaised = true
            }).disposed(by: disposeBag)
        wait(timeout: 0.1)
        giantBombMockClient.mockSimulateFail = false
        
        let gamesFromDriver = try? searchGamesUseCase.gamesDriver.toBlocking().first()
        XCTAssertTrue(isErrorRaised)
        XCTAssertEqual(gamesFromDriver?.count ?? 0, AppSettings.Games.limitPerRequest)
        XCTAssertEqual(searchGamesUseCase.games.count, AppSettings.Games.limitPerRequest)
        XCTAssertTrue(searchGamesUseCase.canDownloadMoreResults)
        XCTAssertEqual(searchGamesUseCase.dataActionState, DataActionStates.none)
    }
    
    func testGameAtIndex() {
        searchGamesUseCase.searchIfNeed()
        wait(timeout: 0.1)
        
        XCTAssertEqual(searchGamesUseCase.game(atIndex: 10)?.id, searchGamesUseCase.games[10].id)
        XCTAssertNil(searchGamesUseCase.game(atIndex: searchGamesUseCase.games.count))
        XCTAssertNil(searchGamesUseCase.game(atIndex: -1))
    }
    
    func testChangeFilters() {
        searchGamesUseCase.searchIfNeed()
        wait(timeout: 0.1)
        
        searchGamesUseCase.change(filters: mockGiantBombMockClientServiceBuilder.searchFilters)
        XCTAssertEqual(searchGamesUseCase.dataActionState, DataActionStates.loading)
        wait(timeout: 0.1)
        
        guard let response: BaseResponseModel<[GameModel]> = jsonModel(mockName: .filteredgames), let filteredGames = response.results else {
            XCTAssertTrue(false)
            return
        }
        for game in searchGamesUseCase.games where !filteredGames.contains(where: { $0.id == game.id }) {
            XCTAssertTrue(false)
            return
        }
    }
}
