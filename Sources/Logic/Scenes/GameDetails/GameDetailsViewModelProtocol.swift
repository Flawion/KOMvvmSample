//
//  GameDetailsViewModelProtocol.swift
//  KOMvvmSample
//
//  Created by Kuba Ostrowski on 11/06/2020.
//

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
