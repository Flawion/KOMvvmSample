//
//  GamesTests.swift
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

final class GamesTests: XCTestCase {
    var gamesViewModel: GamesViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        ApiClientService.setMockClient(forBundle: Bundle(for: type(of: self)))
        gamesViewModel = GamesViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        ApiClientService.giantBomb.mockSimulateFail = false
        super.tearDown()
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
        XCTAssertEqual(gamesViewModel.games.count, ApplicationSettings.Games.limitPerRequest)
        XCTAssertEqual(gamesViewModel.dataState, .none)
    }

    func testDownloadMoreGames() {
        testDownloadGames()
        disposeBag = DisposeBag()

        let promiseMoreGames = expectation(description: "More games returned")

        //try to download more games
        XCTAssertTrue(gamesViewModel.canDownloadMoreResults)
        gamesViewModel.gameObser.filter({$0.count > ApplicationSettings.Games.limitPerRequest}).subscribe(onNext: { _ in
            promiseMoreGames.fulfill()
        }).disposed(by: disposeBag)
        gamesViewModel.searchMoreGames()
        XCTAssertEqual(gamesViewModel.dataState, .loadingMore)

        //then
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
        XCTAssertEqual(gamesViewModel.games.count, ApplicationSettings.Games.limitPerRequest * 2)
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

        XCTAssertTrue(MockSettings.isFileteredGamesMatchFilters(gamesViewModel.games))
        XCTAssertEqual(gamesViewModel.dataState, .none)
    }

    func testGameAtIndex() {
        testDownloadFilteredGames()

        //then
        guard let game = gamesViewModel.game(atIndexPath: IndexPath(row: 0, section: 0)) else {
            XCTAssert(false)
            return
        }
        XCTAssertTrue(MockSettings.isFirstFileteredGameMatch(game))
    }

    func testErrorDownloadGames() {
        ApiClientService.giantBomb.mockSimulateFail = true
        let promiseErrorGames = expectation(description: "Error games returned")

        //try to download games with default filters
        gamesViewModel.searchGamesIfNeed()
        XCTAssertEqual(gamesViewModel.dataState, .loading)
        Observable<Int>.timer(0.5, scheduler: MainScheduler.instance)
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

        ApiClientService.giantBomb.mockSimulateFail = true
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
        ApiClientService.giantBomb.mockSimulateFail = false

        //then
        testDownloadGames()
    }
}
