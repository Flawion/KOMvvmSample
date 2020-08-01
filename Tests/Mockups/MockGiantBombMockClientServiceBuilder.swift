//
//  MockGiantBombMockClientServiceBuilder.swift
//  KOMvvmSample
//
//  Created by Kuba Ostrowski on 01/08/2020.
//

import Foundation

@testable import KOMvvmSampleLogic

final class MockGiantBombMockClientServiceBuilder {
    private(set) var client: GiantBombMockClientService!
    
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
        registerMockGamesData()
        registerMockMoreGamesData()
        registerMockFilteredGamesData()
        registerMockPlatformsData()
        registerMockMorePlatformsData()
        registerMockGameDetailsData()
    }
    
    private func registerMockGamesData() {
        let filters = AppSettings.Games.defaultFilters
        let parameters = client.parametersForSearchGames(offset: 0, limit: AppSettings.Games.limitPerRequest, filters: FiltersUtils.gamesFiltersString(fromFilters: filters), sorting: FiltersUtils.gamesSortingString(fromFilters: filters))
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.games.rawValue, fileType: "json", requestParameters: parameters))
    }
    
    private func registerMockMoreGamesData() {
        let filters = AppSettings.Games.defaultFilters
        let parameters = client.parametersForSearchGames(offset: AppSettings.Games.limitPerRequest, limit: AppSettings.Games.limitPerRequest, filters: FiltersUtils.gamesFiltersString(fromFilters: filters), sorting: FiltersUtils.gamesSortingString(fromFilters: filters))
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.moregames.rawValue, fileType: "json", requestParameters: parameters))
    }
    
    private func registerMockFilteredGamesData() {
        let filters = MockSettings.filteredGamesFilters
        let parameters = client.parametersForSearchGames(offset: 0, limit: AppSettings.Games.limitPerRequest, filters: FiltersUtils.gamesFiltersString(fromFilters: filters), sorting: FiltersUtils.gamesSortingString(fromFilters: filters))
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.filteredgames.rawValue, fileType: "json", requestParameters: parameters))
    }
    
    private func registerMockPlatformsData() {
        let parameters = client.parametersForPlatforms(offset: 0, limit: AppSettings.Platforms.limitPerRequest)
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.platforms.rawValue, fileType: "json", requestParameters: parameters))
    }
    
    private func registerMockMorePlatformsData() {
        let parameters = client.parametersForPlatforms(offset: AppSettings.Platforms.limitPerRequest, limit: AppSettings.Platforms.limitPerRequest)
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.moreplatforms.rawValue, fileType: "json", requestParameters: parameters))
    }
    
    private func registerMockGameDetailsData() {
        let parameters = client.parametersForGameDetails(forGuid: "3030-16909")
        client.mockDataContainer.register(mockData: ApiMockData(fileName: MockSettings.FileNames.gamedetails.rawValue, fileType: "json", requestParameters: parameters))
    }
    
}
