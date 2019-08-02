//
//  BaseGiantBombClient.swift
//  KOMvvmSample
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

enum GiantBombURLComponents: String {
    case game
    case games
    case platforms
}

class BaseGiantBombClient: BaseApiClient {
    override var apiAddress: String {
        return ApplicationSettings.ApiSettings.giantBombAddress + "/api"
    }

    override func createDefaultHeaders() -> [String: String]? {
        return ["Content-Type": "application/json"]
    }

    override func createDefaultParameters() -> [String: Any]? {
        return ["api_key": ApplicationSettings.ApiSettings.apiKey, "format": "json"]
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
