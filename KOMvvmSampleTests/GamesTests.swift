//
//  GamesTests.swift
//  KOMvvmSampleTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import RxSwift
import RxCocoa

@testable import KOMvvmSample

final class GamesTests: XCTestCase {
    private var mockedServices: MockedServices!
    private var gamesViewModel: GamesViewModel!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        
        mockedServices = MockedServices()
        initializeTestScene()
    }
    
    private func initializeTestScene() {
        guard let gamesViewController = GamesSceneBuilder().createScene(withServiceLocator: mockedServices.locator) as? GamesViewController else {
            fatalError("cast failed GamesViewController")
        }
        gamesViewModel = gamesViewController.viewModel
        disposeBag = DisposeBag()
    }

    func testDownloadGames() {
        let promiseGames = expectation(description: "Games returned")

        //try to download games with default filters
        gamesViewModel.gameObser.filter({$0.count > 0}).subscribe(onNext: { _ in
            promiseGames.fulfill()
        }).disposed(by: disposeBag)
        gamesViewModel.searchGamesIfNeed()
        XCTAssertEqual(gamesViewModel.dataState, .loading)

        //then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
        XCTAssertEqual(gamesViewModel.games.count, AppSettings.Games.limitPerRequest)
        XCTAssertEqual(gamesViewModel.dataState, .none)
    }

    func testDownloadMoreGames() {
        testDownloadGames()
        disposeBag = DisposeBag()

        let promiseMoreGames = expectation(description: "More games returned")

        //try to download more games
        XCTAssertTrue(gamesViewModel.canDownloadMoreResults)
        gamesViewModel.gameObser.filter({$0.count > AppSettings.Games.limitPerRequest}).subscribe(onNext: { _ in
            promiseMoreGames.fulfill()
        }).disposed(by: disposeBag)
        gamesViewModel.searchMoreGames()
        XCTAssertEqual(gamesViewModel.dataState, .loadingMore)

        //then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
        XCTAssertEqual(gamesViewModel.games.count, AppSettings.Games.limitPerRequest * 2)
        XCTAssertEqual(gamesViewModel.dataState, .none)
    }

    func testDownloadFilteredGames() {
        let promiseGames = expectation(description: "Games filetered returned")

        //try to change filters
        gamesViewModel.gameObser.filter({$0.count > 0}).subscribe(onNext: { _ in
            promiseGames.fulfill()
        }).disposed(by: disposeBag)
        gamesViewModel.changeGameFilters(MockSettings.filteredGamesFilters)
        XCTAssertEqual(gamesViewModel.dataState, .loading)

        //then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }

        MockSettings.isFileteredGamesMatchFilters(gamesViewModel.games)
        XCTAssertEqual(gamesViewModel.dataState, .none)
    }

    func testGameAtIndex() {
        testDownloadFilteredGames()

        //then
        guard let game = gamesViewModel.game(atIndexPath: IndexPath(row: 0, section: 0)) else {
            XCTAssert(false)
            return
        }
        MockSettings.isFirstFileteredGameMatch(game)
    }

    func testErrorDownloadGames() {
        mockedServices.giantBombMockClient.mockSimulateFail = true
        let promiseErrorGames = expectation(description: "Error games returned")

        //try to download games with default filters
        gamesViewModel.searchGamesIfNeed()
        XCTAssertEqual(gamesViewModel.dataState, .loading)
        Observable<Int>.timer(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in promiseErrorGames.fulfill() })
            .disposed(by: disposeBag)

        //then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
        XCTAssertEqual(gamesViewModel.dataState, .error)
    }

    func testErrorDownloadMoreGames() {
        testDownloadGames()
        disposeBag = DisposeBag()

        mockedServices.giantBombMockClient.mockSimulateFail = true
        let promiseErrorMoreGames = expectation(description: "Error more games returned")

        //try to download more games
        XCTAssertTrue(gamesViewModel.canDownloadMoreResults)
        gamesViewModel.raiseErrorDriver.drive(onNext: { _ in
            promiseErrorMoreGames.fulfill()
        }).disposed(by: disposeBag)
        gamesViewModel.searchMoreGames()
        XCTAssertEqual(gamesViewModel.dataState, .loadingMore)

        //then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
        XCTAssertEqual(gamesViewModel.dataState, .none)
    }

    func testRefreshDownloadGames() {
        testErrorDownloadGames()
        disposeBag = DisposeBag()
        mockedServices.giantBombMockClient.mockSimulateFail = false

        //then
        testDownloadGames()
    }
}
