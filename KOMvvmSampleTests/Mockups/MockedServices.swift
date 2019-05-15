//
//  MockedServices.swift
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
        let filters = ApplicationSettings.Games.defaultFilters
        let parameters = giantBombMockClient.parametersForSearchGames(offset: 0, limit: ApplicationSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: filters), sorting: Utils.shared.gamesSortingString(fromFilters: filters))
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "games", fileType: "json", requestParameters: parameters))
    }

    private func registerMockMoreGamesData() {
        let filters = ApplicationSettings.Games.defaultFilters
        let parameters = giantBombMockClient.parametersForSearchGames(offset: ApplicationSettings.Games.limitPerRequest, limit: ApplicationSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: filters), sorting: Utils.shared.gamesSortingString(fromFilters: filters))
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "moregames", fileType: "json", requestParameters: parameters))
    }

    private func registerMockFilteredGamesData() {
        let filters = MockSettings.filteredGamesFilters
        let parameters = giantBombMockClient.parametersForSearchGames(offset: 0, limit: ApplicationSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: filters), sorting: Utils.shared.gamesSortingString(fromFilters: filters))
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "filteredgames", fileType: "json", requestParameters: parameters))
    }

    private func registerMockPlatformsData() {
        let parameters = giantBombMockClient.parametersForPlatforms(offset: 0, limit: ApplicationSettings.Platforms.limitPerRequest)
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "platforms", fileType: "json", requestParameters: parameters))
    }

    private func registerMockMorePlatformsData() {
        let parameters = giantBombMockClient.parametersForPlatforms(offset: ApplicationSettings.Platforms.limitPerRequest, limit: ApplicationSettings.Platforms.limitPerRequest)
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "moreplatforms", fileType: "json", requestParameters: parameters))
    }

    private func registerMockGameDetailsData() {
        let parameters = giantBombMockClient.parametersForGameDetails(forGuid: "3030-16909")
        giantBombMockClient.mockDataContainer.register(mockData: ApiMockData(fileName: "gamedetails", fileType: "json", requestParameters: parameters))
    }

}
