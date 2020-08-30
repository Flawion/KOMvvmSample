//
//  GamesViewModelTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import RxSwift
import RxCocoa
import RxBlocking

@testable import KOMvvmSampleLogic

final class GamesViewModelTests: XCTestCase {
    private var appCoordinator: MockedAppCoordinator!
    private var giantBombMockClient: GiantBombMockClientService!
    private var gamesViewModel: GamesViewModel!
    
    override func setUp() {
        appCoordinator = MockedAppCoordinator()
        giantBombMockClient = appCoordinator.mockGiantBombClientServiceConfigurator.client!
        let searchGamesUseCase = SearchGamesUseCase(giantBombClient: giantBombMockClient)
        gamesViewModel = GamesViewModel(appCoordinator: appCoordinator, searchGamesUseCase: searchGamesUseCase)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        appCoordinator = nil
        giantBombMockClient = nil
        gamesViewModel = nil
    }
    
    func testIsApiKeyValid() {
        XCTAssertEqual(AppSettings.Api.key.isEmpty, !gamesViewModel.isApiKeyValid)
    }
    
    func testSearchIfNeed() {
        gamesViewModel.searchIfNeed()
        XCTAssertEqual(gamesViewModel.dataActionState, .loading)
        wait(timeout: 0.1)
        
        let gamesFromDriver = try? gamesViewModel.gamesDriver.toBlocking().first()
        XCTAssertEqual(gamesFromDriver?.count ?? 0, AppSettings.Games.limitPerRequest)
        XCTAssertEqual(gamesViewModel.games.count, AppSettings.Games.limitPerRequest)
        XCTAssertTrue(gamesViewModel.canDownloadMoreResults)
        XCTAssertEqual(gamesViewModel.dataActionState, DataActionStates.none)
    }
    
    func testSearchIfNotNeed() {
        gamesViewModel.searchIfNeed()
        wait(timeout: 0.1)
        
        gamesViewModel.searchIfNeed()
        wait(timeout: 0.1)
        
        let gamesFromDriver = try? gamesViewModel.gamesDriver.toBlocking().first()
        XCTAssertEqual(gamesFromDriver?.count ?? 0, AppSettings.Games.limitPerRequest)
        XCTAssertEqual(gamesViewModel.games.count, AppSettings.Games.limitPerRequest)
        XCTAssertTrue(gamesViewModel.canDownloadMoreResults)
        XCTAssertEqual(gamesViewModel.dataActionState, DataActionStates.none)
    }
    
    func testSearchIfNeedWithError() {
        giantBombMockClient.mockSimulateFail = true
        
        gamesViewModel.searchIfNeed()
        XCTAssertEqual(gamesViewModel.dataActionState, DataActionStates.loading)
        wait(timeout: 0.1)
        giantBombMockClient.mockSimulateFail = false
        
        XCTAssertEqual(gamesViewModel.dataActionState, DataActionStates.error)
        let gamesFromDriver = try? gamesViewModel.gamesDriver.toBlocking().first()
        XCTAssertEqual(gamesFromDriver?.count ?? 0, 0)
        XCTAssertEqual(gamesViewModel.games.count, 0)
        XCTAssertFalse(gamesViewModel.canDownloadMoreResults)
    }
    
    func testSearchMore() {
        gamesViewModel.searchIfNeed()
        wait(timeout: 0.1)
        
        gamesViewModel.searchMore()
        XCTAssertEqual(gamesViewModel.dataActionState, DataActionStates.loadingMore)
        wait(timeout: 0.1)
       
        let gamesFromDriver = try? gamesViewModel.gamesDriver.toBlocking().first()
        XCTAssertEqual(gamesFromDriver?.count ?? 0, AppSettings.Games.limitPerRequest * 2)
        XCTAssertEqual(gamesViewModel.games.count, AppSettings.Games.limitPerRequest * 2)
        XCTAssertTrue(gamesViewModel.canDownloadMoreResults)
        XCTAssertEqual(gamesViewModel.dataActionState, DataActionStates.none)
    }
    
    func testSearchMoreWithError() {
        gamesViewModel.searchIfNeed()
        wait(timeout: 0.1)
        var isErrorRaised: Bool = false
        let disposeBag = DisposeBag()
        
        giantBombMockClient.mockSimulateFail = true
        gamesViewModel.searchMore()
        XCTAssertEqual(gamesViewModel.dataActionState, DataActionStates.loadingMore)
        gamesViewModel.raiseErrorDriver.drive(onNext: { _ in
            isErrorRaised = true
            }).disposed(by: disposeBag)
        wait(timeout: 0.1)
        giantBombMockClient.mockSimulateFail = false
        
        let gamesFromDriver = try? gamesViewModel.gamesDriver.toBlocking().first()
        XCTAssertTrue(isErrorRaised)
        XCTAssertEqual(gamesFromDriver?.count ?? 0, AppSettings.Games.limitPerRequest)
        XCTAssertEqual(gamesViewModel.games.count, AppSettings.Games.limitPerRequest)
        XCTAssertTrue(gamesViewModel.canDownloadMoreResults)
        XCTAssertEqual(gamesViewModel.dataActionState, DataActionStates.none)
    }
    
    func testGameAtIndex() {
        gamesViewModel.searchIfNeed()
        wait(timeout: 0.1)
        
        XCTAssertEqual(gamesViewModel.game(atIndex: 10)?.id, gamesViewModel.games[10].id)
        XCTAssertNil(gamesViewModel.game(atIndex: gamesViewModel.games.count))
        XCTAssertNil(gamesViewModel.game(atIndex: -1))
    }
    
    func testChangeFilters() {
        gamesViewModel.searchIfNeed()
        wait(timeout: 0.1)
        let searchFilters = appCoordinator.mockGiantBombClientServiceConfigurator.searchFilters
        
        gamesViewModel.change(filters: searchFilters)
        XCTAssertEqual(gamesViewModel.dataActionState, DataActionStates.loading)
        wait(timeout: 0.1)
        
        guard let response: BaseResponseModel<[GameModel]> = jsonModel(mockName: .filteredgames), let filteredGames = response.results else {
            XCTAssertTrue(false)
            return
        }
        for game in gamesViewModel.games where !filteredGames.contains(where: { $0.id == game.id }) {
            XCTAssertTrue(false)
            return
        }
        if gamesViewModel.filters.first(where: { searchFilters[$0.key] == nil }) != nil {
            XCTAssertTrue(false)
        }
        XCTAssertEqual(gamesViewModel.games.count, filteredGames.count)
    }
}
