//
//  MockGiantBombClientServiceConfigurator.swift
//  KOMvvmSample
//
//  Copyright (c) 2020 Kuba Ostrowskion 01/08/2020.
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

@testable import KOMvvmSampleLogic

final class MockGiantBombClientServiceConfigurator {
    private(set) var client: GiantBombMockClientService!
    
    // MARK: Registered mock parameters
    var searchFilteredGamesName: String {
        return "Mass effect"
    }
    
    var searchFilteredGamesFromDate: Date {
        return Calendar.current.date(from: DateComponents(year: 2006, month: 3, day: 3))!
    }
    
    var searchFilteredGamesToDate: Date {
        return Calendar.current.date(from: DateComponents(year: 2019, month: 3, day: 8))!
    }
    
    var searchFilteredGamesTotalResult: Int {
        return 4
    }
    
    var searchFilteredGamesSortingOptions: String {
        return String(format: "%@:%@", GamesSortingOptions.originalReleaseDate.rawValue, GamesSortingDirections.asc.rawValue)
    }
    
    var searchFilters: [GamesFilters: String] {
        return [GamesFilters.name: searchFilteredGamesName, GamesFilters.sorting: searchFilteredGamesSortingOptions, GamesFilters.originalReleaseDate: FiltersUtils.dateRangeValue(from: searchFilteredGamesFromDate, to: searchFilteredGamesToDate)]
    }
    
    var morePlatformsCount: Int {
        return 57
    }
    
    var gameDetailsGuid: String {
        return "3030-16909"
    }
    
    var gameDetailsName: String {
        return "Mass Effect"
    }
    
    var searchGamesDataParameters: ApiRequestParameters {
        let filters = AppSettings.Games.defaultFilters
        return client.parametersForSearchGames(offset: 0, limit: AppSettings.Games.limitPerRequest, filters: FiltersUtils.gamesFiltersString(fromFilters: filters), sorting: FiltersUtils.gamesSortingString(fromFilters: filters))
    }
    
    var searchMoreGamesDataParameters: ApiRequestParameters {
        let filters = AppSettings.Games.defaultFilters
        return client.parametersForSearchGames(offset: AppSettings.Games.limitPerRequest, limit: AppSettings.Games.limitPerRequest, filters: FiltersUtils.gamesFiltersString(fromFilters: filters), sorting: FiltersUtils.gamesSortingString(fromFilters: filters))
    }
    
    var searchFilteredGamesDataParameters: ApiRequestParameters {
        return client.parametersForSearchGames(offset: 0, limit: AppSettings.Games.limitPerRequest, filters: FiltersUtils.gamesFiltersString(fromFilters: searchFilters), sorting: FiltersUtils.gamesSortingString(fromFilters: searchFilters))
    }
    
    var platformsDataParameters: ApiRequestParameters {
        return client.parametersForPlatforms(offset: 0, limit: AppSettings.Platforms.limitPerRequest)
    }
    
    var morePlatformsDataParameters: ApiRequestParameters {
        return client.parametersForPlatforms(offset: AppSettings.Platforms.limitPerRequest, limit: AppSettings.Platforms.limitPerRequest)
    }
    
    var gameDetailsDataParameters: ApiRequestParameters {
        return client.parametersForGameDetails(forGuid: gameDetailsGuid)
    }
    
    init(serviceLocator: ServiceLocator) {
        registerClientIfNeed(serviceLocator: serviceLocator)
        initializeClient(serviceLocator: serviceLocator)
        registerMockData()
    }
    
    deinit {
        client = nil
    }
    
    private func registerClientIfNeed(serviceLocator: ServiceLocator) {
        let giantBombMockClient: GiantBombClientServiceProtocol? = serviceLocator.get(type: .giantBombApiClient)
        if giantBombMockClient == nil {
            serviceLocator.register(withBuilder: GiantBombMockClientServiceBuilder())
        }
    }
    
    private func initializeClient(serviceLocator: ServiceLocator) {
        guard let giantBombMockClient: GiantBombMockClientService = serviceLocator.get(type: .giantBombApiClient) else {
            fatalError("MockedServices can't get giantBombApiClient service")
        }
        giantBombMockClient.mockDataContainer.loadDataFromBundleIdentifier = Bundle(for: type(of: self)).bundleIdentifier
        self.client = giantBombMockClient
    }
    
    // MARK: Register mock data
    private func registerMockData() {
        registerSearchGamesData()
        registerSearchMoreGamesData()
        registerSearchFilteredGamesData()
        registerPlatformsData()
        registerMorePlatformsData()
        registerGameDetailsData()
    }
    
    private func registerSearchGamesData() {
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.games.rawValue, fileType: "json", requestParameters: searchGamesDataParameters))
    }
    
    private func registerSearchMoreGamesData() {
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.moregames.rawValue, fileType: "json", requestParameters: searchMoreGamesDataParameters))
    }
    
    private func registerSearchFilteredGamesData() {
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.filteredgames.rawValue, fileType: "json", requestParameters: searchFilteredGamesDataParameters))
    }
    
    private func registerPlatformsData() {
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.platforms.rawValue, fileType: "json", requestParameters: platformsDataParameters))
    }
    
    private func registerMorePlatformsData() {
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.moreplatforms.rawValue, fileType: "json", requestParameters: morePlatformsDataParameters))
    }
    
    private func registerGameDetailsData() {
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.gamedetails.rawValue, fileType: "json", requestParameters: gameDetailsDataParameters))
    }
    
}
