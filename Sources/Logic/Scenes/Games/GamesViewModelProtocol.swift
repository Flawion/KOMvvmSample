//
//  GamesViewModelProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import RxSwift
import RxCocoa

protocol GamesViewModelProtocol: ViewModelProtocol {
    var filters: [GamesFilters: String] { get }
    var gamesDriver: Driver<[GameModel]> { get }
    var games: [GameModel] { get }
    var canDownloadMoreResults: Bool { get }
    
    func searchMore()
    func searchIfNeed(force: Bool)
    func game(atIndex index: Int) -> GameModel?
    func change(filters gameFilters: [GamesFilters: String?])
    func goToGameDetail(_ game: GameModel, navigationController: UINavigationController?)
    func goToGamesFilter(navigationController: UINavigationController?)
}

extension GamesViewModelProtocol {
    func searchIfNeed(force: Bool = false) {
        searchIfNeed(force: force)
    }
}
