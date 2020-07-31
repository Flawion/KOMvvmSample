//
//  GameDetailsViewModelProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import RxSwift
import RxCocoa

public protocol GameDetailsViewModelProtocol: ViewModelProtocol {
    var game: GameModel { get }
    var gameDriver: Driver<GameModel> { get }
    var gameDetails: GameDetailsModel? { get }
    var gameDetailsDriver: Driver<GameDetailsModel?> { get }
    var gameDetailsItems: [GameDetailsItemModel] { get }
    var gameDetailsItemsDriver: Driver<[GameDetailsItemModel]> { get }
    
    func gameDetailsItem(forIndex index: Int) -> GameDetailsItemModel?
    func downloadGameDetailsIfNeed(refresh: Bool)
    func goToOverviewDetailsItem(_ detailsItem: GameDetailsItemModel, navigationController: UINavigationController?)
    func goToImagesDetailsItem(navigationController: UINavigationController?)
}

public extension GameDetailsViewModelProtocol {
    func downloadGameDetailsIfNeed(refresh: Bool = false) {
        downloadGameDetailsIfNeed(refresh: refresh)
    }
}
