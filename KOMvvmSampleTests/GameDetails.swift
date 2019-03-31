//
//  GameDetails.swift
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

final class GameDetailsTests: XCTestCase {
    var gameDetailsViewModel: GameDetailsViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        ApiClientService.setMockClient(forBundle: Bundle(for: type(of: self)))

        //gets game model for tests
        let filters = MockSettings.filteredGamesFilters
        let data = ApiClientService.giantBomb.mockDataContainer.loadMockData(forRequestParameters: ApiClientService.giantBomb.parametersForSearchGames(offset: 0, limit: ApplicationSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: filters), sorting: Utils.shared.gamesSortingString(fromFilters: filters)))
        guard let gameData = data, let games: BaseResponseModel<[GameModel]>? = try? ApiClientService.giantBomb.defaultDataMapper().mapTo(data: gameData), let firstGame =  games?.results?.first else {
            XCTAssert(false)
            return
        }

        gameDetailsViewModel = GameDetailsViewModel(game: firstGame)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        ApiClientService.giantBomb.mockSimulateFail = false
        super.tearDown()
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
        ApiClientService.giantBomb.mockSimulateFail = true
        let promiseError = expectation(description: "Error returned")

        //try to download game details
        gameDetailsViewModel.downloadGameDetailsIfNeed()
        XCTAssertEqual(gameDetailsViewModel.dataState, .loading)
        Observable<Int>.timer(0.5, scheduler: MainScheduler.instance)
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
        ApiClientService.giantBomb.mockSimulateFail = false

        //then
        testDownloadGameDetails()
    }
}
