//
//  GiantBombClientService.swift
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

final class GiantBombClientServiceBuilder: ServiceBuilderProtocol {
    var type: ServiceTypes {
        return .giantBombApiClient
    }

    func createService(withServiceLocator serviceLocator: ServiceLocator) -> Any {
        return GiantBombClientService()
    }
}

final class GiantBombClientService: BaseGiantBombClient {
    
}

// MARK: GiantBombClientProtocol
extension GiantBombClientService: GiantBombClientServiceProtocol {
    func gameDetails(forGuid guid: String) -> Observable<(HTTPURLResponse, BaseResponseModel<GameDetailsModel>?)> {
        return responseMapped(parameters: parametersForGameDetails(forGuid: guid))
    }

    func searchGames(offset: Int, limit: Int, filters: String, sorting: String) -> Observable<(HTTPURLResponse, BaseResponseModel<[GameModel]>?)> {
        return responseMapped(parameters: parametersForSearchGames(offset: offset, limit: limit, filters: filters, sorting: sorting))
    }

    func platforms(offset: Int, limit: Int, sorting: String) -> Observable<(HTTPURLResponse, BaseResponseModel<[PlatformModel]>?)> {
        return responseMapped(parameters: parametersForPlatforms(offset: offset, limit: limit, sorting: sorting))
    }
}
