//
//  GiantBombClientServiceTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import KOInject

@testable import KOMvvmSampleLogic

final class GiantBombClientServiceTests: XCTestCase {
    
    private var container: KOIContainer!
    private var mockGiantBombClientServiceConfigurator: MockGiantBombClientServiceConfigurator!
    private var giantBombMockClient: GiantBombMockClientService!
    
    override func setUp() {
        container = KOIContainer()
        mockGiantBombClientServiceConfigurator = MockGiantBombClientServiceConfigurator(container: container)
        giantBombMockClient = MockGiantBombClientServiceConfigurator(container: container).client
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        container = nil
        mockGiantBombClientServiceConfigurator = nil
        giantBombMockClient = nil
    }
    
    func testSearchGames() {
        let parameters = mockGiantBombClientServiceConfigurator.searchGamesDataParameters.parameters ?? [:]
        let offset = parameters["offset"] as? Int ?? 0
        let limit = parameters["limit"] as? Int ?? 0
        let filters = parameters["filter"] as? String ?? ""
        let sorting = parameters["sort"] as? String ?? ""
        
        let results: (HTTPURLResponse, BaseResponseModel<[GameModel]>?)? = try? giantBombMockClient.searchGames(offset: offset, limit: limit, filters: filters, sorting: sorting)
            .toBlocking().first()
        guard let response = results?.0, let games = results?.1 else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(games.results?.count, limit)
        XCTAssertEqual(games.offset, offset)
        XCTAssertEqual(games.limit, limit)
    }
    
    func testSearchGamesMore() {
        let parameters = mockGiantBombClientServiceConfigurator.searchMoreGamesDataParameters.parameters ?? [:]
        let offset = parameters["offset"] as? Int ?? 0
        let limit = parameters["limit"] as? Int ?? 0
        let filters = parameters["filter"] as? String ?? ""
        let sorting = parameters["sort"] as? String ?? ""
        
        let results: (HTTPURLResponse, BaseResponseModel<[GameModel]>?)? = try? giantBombMockClient.searchGames(offset: offset, limit: limit, filters: filters, sorting: sorting)
            .toBlocking().first()
        guard let response = results?.0, let games = results?.1 else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(games.results?.count, limit)
        XCTAssertEqual(games.offset, offset)
        XCTAssertEqual(games.limit, limit)
    }
    
    func testSearchFilteredGames() {
        let parameters = mockGiantBombClientServiceConfigurator.searchFilteredGamesDataParameters.parameters ?? [:]
        let offset = parameters["offset"] as? Int ?? 0
        let limit = parameters["limit"] as? Int ?? 0
        let filters = parameters["filter"] as? String ?? ""
        let sorting = parameters["sort"] as? String ?? ""
        let searchFilteredGamesName = mockGiantBombClientServiceConfigurator.searchFilteredGamesName.lowercased()
        let searchFilteredGamesFromDate = mockGiantBombClientServiceConfigurator.searchFilteredGamesFromDate
        let searchFilteredGamesToDate = mockGiantBombClientServiceConfigurator.searchFilteredGamesToDate
        
        let results: (HTTPURLResponse, BaseResponseModel<[GameModel]>?)? = try? giantBombMockClient.searchGames(offset: offset, limit: limit, filters: filters, sorting: sorting)
            .toBlocking().first()
        guard let response = results?.0, let games = results?.1 else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(games.results?.count, mockGiantBombClientServiceConfigurator.searchFilteredGamesTotalResult)
        XCTAssertEqual(games.offset, offset)
        XCTAssertEqual(games.limit, limit)
        let gameWithWrongName = games.results?.first(where: { !$0.name.lowercased().starts(with: searchFilteredGamesName) })
        var lastGameDate: Date = searchFilteredGamesFromDate
        let gameWithWrongDate = games.results?.first(where: {
            guard let originalReleaseDate = $0.originalReleaseDate else {
                return true
            }
            XCTAssertTrue(originalReleaseDate > lastGameDate, "sorting type is not asc")
            lastGameDate = originalReleaseDate
            return !(originalReleaseDate >= searchFilteredGamesFromDate && originalReleaseDate <= searchFilteredGamesToDate)
        })
        XCTAssertNil(gameWithWrongName)
        XCTAssertNil(gameWithWrongDate)
    }
    
    func testPlatforms() {
        let parameters = mockGiantBombClientServiceConfigurator.platformsDataParameters.parameters ?? [:]
        let offset = parameters["offset"] as? Int ?? 0
        let limit = parameters["limit"] as? Int ?? 0
        
        let results: (HTTPURLResponse, BaseResponseModel<[PlatformModel]>?)? = try? giantBombMockClient.platforms(offset: offset, limit: limit)
            .toBlocking().first()
        guard let response = results?.0, let platforms = results?.1 else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(platforms.results?.count, limit)
        XCTAssertEqual(platforms.offset, offset)
        XCTAssertEqual(platforms.limit, limit)
    }
    
    func testMorePlatforms() {
        let parameters = mockGiantBombClientServiceConfigurator.morePlatformsDataParameters.parameters ?? [:]
        let offset = parameters["offset"] as? Int ?? 0
        let limit = parameters["limit"] as? Int ?? 0
        
        let results: (HTTPURLResponse, BaseResponseModel<[PlatformModel]>?)? = try? giantBombMockClient.platforms(offset: offset, limit: limit)
            .toBlocking().first()
        guard let response = results?.0, let platforms = results?.1 else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(platforms.results?.count, mockGiantBombClientServiceConfigurator.morePlatformsCount)
        XCTAssertEqual(platforms.offset, offset)
        XCTAssertEqual(platforms.limit, limit)
    }
    
    func testGameDetails() {
        let gameDetailsGuid = mockGiantBombClientServiceConfigurator.gameDetailsGuid
        
        let results: (HTTPURLResponse, BaseResponseModel<GameDetailsModel>?)? = try? giantBombMockClient.gameDetails(forGuid: gameDetailsGuid)
            .toBlocking().first()
        guard let response = results?.0, let gameDetails = results?.1 else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(gameDetails.results?.name, mockGiantBombClientServiceConfigurator.gameDetailsName)
        XCTAssertEqual(gameDetails.results?.guid, mockGiantBombClientServiceConfigurator.gameDetailsGuid)
    }
}
