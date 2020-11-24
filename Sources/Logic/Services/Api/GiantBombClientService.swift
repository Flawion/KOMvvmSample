//
//  GiantBombClientService.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

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
