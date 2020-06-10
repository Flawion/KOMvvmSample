//
//  GamesViewModelProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import RxSwift
import RxCocoa

protocol GamesViewModelProtocol {
    var gamesFilters: [GamesFilters: String] { get }
    var gameObser: Observable<[GameModel]> { get }
    var games: [GameModel] { get }
    var canDownloadMoreResults: Bool { get }
    
    func searchMoreGames()
    func searchGamesIfNeed(forceRefresh: Bool)
    func game(atIndexPath indexPath: IndexPath) -> GameModel?
    func changeGameFilters(_ gameFilters: [GamesFilters: String?])
    func goToGameDetail(_ game: GameModel, navigationController: UINavigationController?)
    func goToGamesFilter(navigationController: UINavigationController?)
}
