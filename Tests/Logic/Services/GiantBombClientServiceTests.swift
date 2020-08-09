//
//  GiantBombClientServiceTests.swift
//  KOMvvmSampleLogicTests
//
//  Created by Kuba Ostrowski on 01/08/2020.
//

import XCTest

@testable import KOMvvmSampleLogic

final class GiantBombClientServiceTests: XCTestCase {
    
    private var serviceLocator: ServiceLocator!
    private var mockGiantBombMockClientServiceBuilder: MockGiantBombMockClientServiceBuilder!
    private var giantBombMockClient: GiantBombMockClientService!
    
    override func setUp() {
        serviceLocator = ServiceLocator()
        mockGiantBombMockClientServiceBuilder = MockGiantBombMockClientServiceBuilder(serviceLocator: serviceLocator)
        giantBombMockClient = MockGiantBombMockClientServiceBuilder(serviceLocator: serviceLocator).client
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        serviceLocator = nil
        mockGiantBombMockClientServiceBuilder = nil
        giantBombMockClient = nil
    }
    
    func testSearchGames() {
        let parameters = mockGiantBombMockClientServiceBuilder.searchGamesDataParameters.parameters ?? [:]
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
        let parameters = mockGiantBombMockClientServiceBuilder.searchMoreGamesDataParameters.parameters ?? [:]
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
        let parameters = mockGiantBombMockClientServiceBuilder.searchFilteredGamesDataParameters.parameters ?? [:]
        let offset = parameters["offset"] as? Int ?? 0
        let limit = parameters["limit"] as? Int ?? 0
        let filters = parameters["filter"] as? String ?? ""
        let sorting = parameters["sort"] as? String ?? ""
        let searchFilteredGamesName = mockGiantBombMockClientServiceBuilder.searchFilteredGamesName.lowercased()
        let searchFilteredGamesFromDate = mockGiantBombMockClientServiceBuilder.searchFilteredGamesFromDate
        let searchFilteredGamesToDate = mockGiantBombMockClientServiceBuilder.searchFilteredGamesToDate
        
        let results: (HTTPURLResponse, BaseResponseModel<[GameModel]>?)? = try? giantBombMockClient.searchGames(offset: offset, limit: limit, filters: filters, sorting: sorting)
            .toBlocking().first()
        guard let response = results?.0, let games = results?.1 else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(games.results?.count, mockGiantBombMockClientServiceBuilder.searchFilteredGamesTotalResult)
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
        let parameters = mockGiantBombMockClientServiceBuilder.platformsDataParameters.parameters ?? [:]
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
        let parameters = mockGiantBombMockClientServiceBuilder.morePlatformsDataParameters.parameters ?? [:]
        let offset = parameters["offset"] as? Int ?? 0
        let limit = parameters["limit"] as? Int ?? 0
        
        let results: (HTTPURLResponse, BaseResponseModel<[PlatformModel]>?)? = try? giantBombMockClient.platforms(offset: offset, limit: limit)
            .toBlocking().first()
        guard let response = results?.0, let platforms = results?.1 else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(platforms.results?.count, mockGiantBombMockClientServiceBuilder.morePlatformsCount)
        XCTAssertEqual(platforms.offset, offset)
        XCTAssertEqual(platforms.limit, limit)
    }
    
    func testGameDetails() {
        let gameDetailsGuid = mockGiantBombMockClientServiceBuilder.gameDetailsGuid
        
        let results: (HTTPURLResponse, BaseResponseModel<GameDetailsModel>?)? = try? giantBombMockClient.gameDetails(forGuid: gameDetailsGuid)
            .toBlocking().first()
        guard let response = results?.0, let gameDetails = results?.1 else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(gameDetails.results?.name, mockGiantBombMockClientServiceBuilder.gameDetailsName)
        XCTAssertEqual(gameDetails.results?.guid, mockGiantBombMockClientServiceBuilder.gameDetailsGuid)
    }
}
