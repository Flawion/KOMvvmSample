//
//  GiantBombMockClient.swift
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
import Alamofire
import RxSwift
import RxAlamofire

final class GiantBombMockClientServiceBuilder: ServiceBuilder<GiantBombClientServiceProtocol> {
    private let loadDataFromBundleIdentifier: String?

    init(loadDataFromBundleIdentifier: String?) {
        self.loadDataFromBundleIdentifier = loadDataFromBundleIdentifier
    }
    
    override func createService<GiantBombClientServiceProtocol>(withServiceLocator serviceLocator: ServiceLocator) -> GiantBombClientServiceProtocol {
        let clientService = GiantBombMockClientService()
        clientService.mockDataContainer.loadDataFromBundleIdentifier = loadDataFromBundleIdentifier
        return clientService as! GiantBombClientServiceProtocol
    }
}

// MARK: - Mock client registers the fake data

/// Used in unit tests
final class GiantBombMockClientService: BaseGiantBombClient {
    override init() {
        super.init()
        
        registerMockData()
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
        let parameters = parametersForSearchGames(offset: 0, limit: ApplicationSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: filters), sorting: Utils.shared.gamesSortingString(fromFilters: filters))
        mockDataContainer.register(mockData: ApiMockData(fileName: "games", fileType: "json", requestParameters: parameters))
    }
    
    private func registerMockMoreGamesData() {
        let filters = ApplicationSettings.Games.defaultFilters
        let parameters = parametersForSearchGames(offset: ApplicationSettings.Games.limitPerRequest, limit: ApplicationSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: filters), sorting: Utils.shared.gamesSortingString(fromFilters: filters))
        mockDataContainer.register(mockData: ApiMockData(fileName: "moregames", fileType: "json", requestParameters: parameters))
    }
    
    private func registerMockFilteredGamesData() {
        let filters = MockSettings.filteredGamesFilters
        let parameters = parametersForSearchGames(offset: 0, limit: ApplicationSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: filters), sorting: Utils.shared.gamesSortingString(fromFilters: filters))
        mockDataContainer.register(mockData: ApiMockData(fileName: "filteredgames", fileType: "json", requestParameters: parameters))
    }
    
    private func registerMockPlatformsData() {
        let parameters = parametersForPlatforms(offset: 0, limit: ApplicationSettings.Platforms.limitPerRequest)
        mockDataContainer.register(mockData: ApiMockData(fileName: "platforms", fileType: "json", requestParameters: parameters))
    }
    
    private func registerMockMorePlatformsData() {
        let parameters = parametersForPlatforms(offset: ApplicationSettings.Platforms.limitPerRequest, limit: ApplicationSettings.Platforms.limitPerRequest)
        mockDataContainer.register(mockData: ApiMockData(fileName: "moreplatforms", fileType: "json", requestParameters: parameters))
    }
    
    private func registerMockGameDetailsData() {
        let parameters = parametersForGameDetails(forGuid: "3030-16909")
        mockDataContainer.register(mockData: ApiMockData(fileName: "gamedetails", fileType: "json", requestParameters: parameters))
    }
}

// MARK: - GiantBombClientProtocol
extension GiantBombMockClientService: GiantBombClientServiceProtocol {
    func gameDetails(forGuid guid: String) -> Observable<(HTTPURLResponse, BaseResponseModel<GameDetailsModel>?)> {
        return responseMockMapped(parameters: parametersForGameDetails(forGuid: guid))
    }

    func searchGames(offset: Int, limit: Int, filters: String, sorting: String) -> Observable<(HTTPURLResponse, BaseResponseModel<[GameModel]>?)> {
        return responseMockMapped(parameters: parametersForSearchGames(offset: offset, limit: limit, filters: filters, sorting: sorting))
    }

    func platforms(offset: Int, limit: Int, sorting: String) -> Observable<(HTTPURLResponse, BaseResponseModel<[PlatformModel]>?)> {
        return responseMockMapped(parameters: parametersForPlatforms(offset: offset, limit: limit, sorting: sorting))
    }
}
