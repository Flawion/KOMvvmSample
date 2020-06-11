//
//  MockedServices.swift
//  KOMvvmSampleTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

@testable import KOMvvmSample

final class MockedServices {
    var locator: ServiceLocator!
    var giantBombMockClient: GiantBombMockClientService!
    
    init() {
        initializeServiceLocator()
        initializeGiantBombMockClient()
        registerMockData()
    }
    
    private func initializeServiceLocator() {
        locator = ServiceLocator()
        locator.register(withBuilder: GiantBombMockClientServiceBuilder())
        locator.register(withBuilder: DataStoreServiceBuilder())
        locator.register(withBuilder: PlatformsServiceBuilder())
    }
    
    private func initializeGiantBombMockClient() {
        guard let giantBombMockClient: GiantBombMockClientService = locator.get(type: .giantBombApiClient) else {
            fatalError("MockedServices can't get giantBombApiClient service")
        }
        giantBombMockClient.mockDataContainer.loadDataFromBundleIdentifier = Bundle(for: type(of: self)).bundleIdentifier
        self.giantBombMockClient = giantBombMockClient
    }

    // MARK: Register mock data
    private func registerMockData() {
        registerMockGamesData()
        registerMockMoreGamesData()
        registerMockFilteredGamesData()
        registerMockPlatformsData()
        registerMockMorePlatformsData()
        registerMockGameDetailsData()
    }

    private func registerMockGamesData() {
        let filters = AppSettings.Games.defaultFilters
        let parameters = giantBombMockClient.parametersForSearchGames(offset: 0, limit: AppSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: filters), sorting: Utils.shared.gamesSortingString(fromFilters: filters))
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "games", fileType: "json", requestParameters: parameters))
    }

    private func registerMockMoreGamesData() {
        let filters = AppSettings.Games.defaultFilters
        let parameters = giantBombMockClient.parametersForSearchGames(offset: AppSettings.Games.limitPerRequest, limit: AppSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: filters), sorting: Utils.shared.gamesSortingString(fromFilters: filters))
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "moregames", fileType: "json", requestParameters: parameters))
    }

    private func registerMockFilteredGamesData() {
        let filters = MockSettings.filteredGamesFilters
        let parameters = giantBombMockClient.parametersForSearchGames(offset: 0, limit: AppSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: filters), sorting: Utils.shared.gamesSortingString(fromFilters: filters))
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "filteredgames", fileType: "json", requestParameters: parameters))
    }

    private func registerMockPlatformsData() {
        let parameters = giantBombMockClient.parametersForPlatforms(offset: 0, limit: AppSettings.Platforms.limitPerRequest)
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "platforms", fileType: "json", requestParameters: parameters))
    }

    private func registerMockMorePlatformsData() {
        let parameters = giantBombMockClient.parametersForPlatforms(offset: AppSettings.Platforms.limitPerRequest, limit: AppSettings.Platforms.limitPerRequest)
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "moreplatforms", fileType: "json", requestParameters: parameters))
    }

    private func registerMockGameDetailsData() {
        let parameters = giantBombMockClient.parametersForGameDetails(forGuid: "3030-16909")
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "gamedetails", fileType: "json", requestParameters: parameters))
    }

}
