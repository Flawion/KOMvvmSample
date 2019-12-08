//
//  GiantBombClientServiceProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift

protocol GiantBombClientServiceProtocol: NSObjectProtocol {
    func gameDetails(forGuid guid: String) -> Observable<(HTTPURLResponse, BaseResponseModel<GameDetailsModel>?)>

    func searchGames(offset: Int, limit: Int, filters: String, sorting: String) -> Observable<(HTTPURLResponse, BaseResponseModel<[GameModel]>?)>

    func platforms(offset: Int, limit: Int, sorting: String) -> Observable<(HTTPURLResponse, BaseResponseModel<[PlatformModel]>?)>
}

extension GiantBombClientServiceProtocol {
    func platforms(offset: Int, limit: Int, sorting: String = "name:asc") -> Observable<(HTTPURLResponse, BaseResponseModel<[PlatformModel]>?)> {
        return platforms(offset: offset, limit: limit, sorting: sorting)
    }
}
