//
//  GameDetails.swift
//  KOMvvmSampleTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import RxSwift
import RxCocoa

@testable import KOMvvmSample

final class GameDetailsTests: XCTestCase {
    private var mockedServices: MockedServices!
    private var gameDetailsViewModel: GameDetailsViewModel!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        
        mockedServices = MockedServices()
        initializeTestScene()
    }
    
    private func initializeTestScene() {
        guard let firstGame = getFirstGameFromMockData() else {
            return
        }
        guard let gameDetailsViewController = GameDetailsSceneBuilder(game: firstGame).createScene(withServiceLocator: mockedServices.locator) as? GameDetailsViewController else {
            fatalError("cast failed GameDetailsViewController")
        }
        gameDetailsViewModel = gameDetailsViewController.viewModel
        disposeBag = DisposeBag()
    }
    
    private func getFirstGameFromMockData() -> GameModel? {
        let filters = MockSettings.filteredGamesFilters
        let data = mockedServices.giantBombMockClient.mockDataContainer.loadMockData(forRequestParameters: mockedServices.giantBombMockClient.parametersForSearchGames(offset: 0, limit: AppSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: filters), sorting: Utils.shared.gamesSortingString(fromFilters: filters)))
        guard let gameData = data, let games: BaseResponseModel<[GameModel]>? = try? mockedServices.giantBombMockClient.defaultDataMapper().mapTo(data: gameData), let firstGame =  games?.results?.first else {
            XCTAssert(false)
            return nil
        }
        return firstGame
    }
    
    func testDownloadGameDetails() {
        let promiseGameDetails = expectation(description: "Game details returned")
        promiseGameDetails.expectedFulfillmentCount = 2

        //try to download game details
        gameDetailsViewModel.gameDetailsDriver.filter({$0 != nil})
            .drive(onNext: { _ in
                promiseGameDetails.fulfill()
            }).disposed(by: disposeBag)

        gameDetailsViewModel.gameDetailsItemsObser.filter({$0.count > 0})
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, self.gameDetailsViewModel.gameDetails != nil else {
                    return
                }
                promiseGameDetails.fulfill()
            }).disposed(by: disposeBag)

        gameDetailsViewModel.downloadGameDetailsIfNeed()
        XCTAssertEqual(gameDetailsViewModel.dataState, .loading)

        //then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
        XCTAssertEqual(gameDetailsViewModel.dataState, .none)
    }

    func testErrorDownloadGameDetails() {
        mockedServices.giantBombMockClient.mockSimulateFail = true
        let promiseError = expectation(description: "Error returned")

        //try to download game details
        gameDetailsViewModel.downloadGameDetailsIfNeed()
        XCTAssertEqual(gameDetailsViewModel.dataState, .loading)
        Observable<Int>.timer(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in promiseError.fulfill() })
            .disposed(by: disposeBag)

        //then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
        XCTAssertEqual(gameDetailsViewModel.dataState, .error)
    }

    func testRefreshDownloadGameDetails() {
        testErrorDownloadGameDetails()
        disposeBag = DisposeBag()
        mockedServices.giantBombMockClient.mockSimulateFail = false

        //then
        testDownloadGameDetails()
    }
}
