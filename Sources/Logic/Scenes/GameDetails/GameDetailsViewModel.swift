//
//  GameDetailsViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa

final class GameDetailsViewModel: BaseViewModel {
    private let gameDetailsUseCase: GameDetailsUseCase
    
    // MARK: Functions
    init(appCoordinator: AppCoordinatorProtocol, gameDetailsUseCase: GameDetailsUseCase) {
        self.gameDetailsUseCase = gameDetailsUseCase
        super.init(appCoordinator: appCoordinator)
        forward(dataControllerState: gameDetailsUseCase)
    }
}

// MARK: - GameDetailsViewModelProtocol
extension GameDetailsViewModel: GameDetailsViewModelProtocol {
    
    var gameDriver: Driver<GameModel> {
        return gameDetailsUseCase.gameDriver
    }
    
    var game: GameModel {
        return gameDetailsUseCase.game
    }
    
    var gameDetails: GameDetailsModel? {
        return gameDetailsUseCase.gameDetails
    }
    
    var gameDetailsDriver: Driver<GameDetailsModel?> {
        return gameDetailsUseCase.gameDetailsDriver
    }
    
    var gameDetailsItems: [GameDetailsItemModel] {
        return gameDetailsUseCase.gameDetailsItems
    }
    
    var gameDetailsItemsDriver: Driver<[GameDetailsItemModel]> {
        return gameDetailsUseCase.gameDetailsItemsDriver
    }
    
    func gameDetailsItem(forIndex index: Int) -> GameDetailsItemModel? {
        return gameDetailsUseCase.gameDetailsItem(forIndex: index)
    }
    
    func downloadGameDetailsIfNeed(refresh: Bool = false) {
        gameDetailsUseCase.downloadIfNeed(force: refresh)
    }
    
    // MARK: Navigation
    func goToOverviewDetailsItem(_ detailsItem: GameDetailsItemModel, navigationController: UINavigationController?) {
        _ = appCoordinator?.transition(.push(onNavigationController: navigationController), scene: WebViewSceneBuilder(barTitle: detailsItem.localizedName, html: game.description ?? ""))
    }
    
    func goToImagesDetailsItem(navigationController: UINavigationController?) {
        guard let images = gameDetails?.images else {
            return
        }
        _ = appCoordinator?.transition(.push(onNavigationController: navigationController), scene: GameImagesSceneBuilder(images: images))
    }
}
