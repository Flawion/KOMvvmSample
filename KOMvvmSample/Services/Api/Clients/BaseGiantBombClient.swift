//
//  BaseGiantBombClient.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

enum GiantBombURLComponents: String {
    case game
    case games
    case platforms
}

class BaseGiantBombClient: BaseApiClient {
    override var apiAddress: String {
        return AppSettings.Api.giantBombAddress + "/api"
    }

    override func createDefaultHeaders() -> [String: String]? {
        return ["Content-Type": "application/json"]
    }

    override func createDefaultParameters() -> [String: Any]? {
        return ["api_key": AppSettings.Api.key, "format": "json"]
    }

    override init() {
        super.init()
        initializeDefaultMapper()
    }
    
    private func initializeDefaultMapper() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en-US")
        (ApiDataToJsonMapper.default as? ApiDataToJsonMapper)?.dateFormatStrategy = .formatted(formatter)
    }
    
    // MARK: Parameters for requests
    func parametersForGameDetails(forGuid guid: String) -> ApiRequestParameters {
        return ApiRequestParameters(url: urlBuilder.build(components: [GiantBombURLComponents.game.rawValue, guid])!, method: .get)
    }
    
    func parametersForSearchGames(offset: Int, limit: Int, filters: String, sorting: String) -> ApiRequestParameters {
        let url = urlBuilder.build(components: [GiantBombURLComponents.games.rawValue])!
        var parameters: [String: Any] = ["limit": limit, "offset": offset, "sort": sorting]
        if !filters.isEmpty {
            parameters["filter"] = filters
        }
        return ApiRequestParameters(url: url, method: .get, parameters: parameters)
    }
    
    func parametersForPlatforms(offset: Int, limit: Int, sorting: String = "name:asc") -> ApiRequestParameters {
        return ApiRequestParameters(url: urlBuilder.build(components: [GiantBombURLComponents.platforms.rawValue])!, method: .get, parameters: ["limit": limit, "offset": offset, "sort": sorting])
    }
}
