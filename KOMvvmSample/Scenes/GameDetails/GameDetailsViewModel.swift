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
    // MARK: Variables
    private var giantBombClient: GiantBombClientServiceProtocol!

    private let gameVar: BehaviorRelay<GameModel>
    private let gameDetailsVar: BehaviorRelay<GameDetailsModel?> = BehaviorRelay<GameDetailsModel?>(value: nil)
    private let gameDetailsItemsVar: BehaviorRelay<[GameDetailsItemModel]> = BehaviorRelay<[GameDetailsItemModel]>(value: [])

    private var gameDetailsDisposeBag: DisposeBag!
    private let disposeBag: DisposeBag = DisposeBag()

    var gameDriver: Driver<GameModel> {
        return gameVar.asDriver()
    }

    var game: GameModel {
        return gameVar.value
    }

    var gameDetails: GameDetailsModel? {
        return gameDetailsVar.value
    }

    var gameDetailsDriver: Driver<GameDetailsModel?> {
        return gameDetailsVar.asDriver()
    }

    var gameDetailsItems: [GameDetailsItemModel] {
        return gameDetailsItemsVar.value
    }

    var gameDetailsItemsObser: Observable<[GameDetailsItemModel]> {
        return gameDetailsItemsVar.asObservable()
    }

    var gameDetailsItemsDriver: Driver<[GameDetailsItemModel]> {
        return gameDetailsItemsVar.asDriver()
    }

    // MARK: Functions
    init(appCoordinator: AppCoordinatorProtocol, giantBombClient: GiantBombClientServiceProtocol, game: GameModel) {
        self.giantBombClient = giantBombClient
        gameVar = BehaviorRelay<GameModel>(value: game)
        super.init(appCoordinator: appCoordinator)

        generateGameDetailItems()
    }

    private func generateGameDetailItems() {
        Observable<[GameDetailsItemModel]>.combineLatest(gameVar.asObservable(), gameDetailsVar.asObservable()) { [weak self] (game, gameDetails) -> [GameDetailsItemModel] in
            var detailsItems: [GameDetailsItemModel] = []

            guard let self = self else {
                return detailsItems
            }

            self.appendOverviewToDetailsItems(&detailsItems, ifDescriptionNotEmpty: game.description)
            self.appendToDetailsItems(&detailsItems, resourcesFromGameDetails: gameDetails)
            return detailsItems
            }.bind(to: gameDetailsItemsVar).disposed(by: disposeBag)
    }

    private func appendOverviewToDetailsItems(_ detailsItems: inout [GameDetailsItemModel], ifDescriptionNotEmpty description: String?) {
        guard !(game.description?.isEmpty ?? true) else {
            return
        }
        detailsItems.append(GameDetailsItemModel(item: .overview, contentSize: 0))
    }

    private func appendToDetailsItems(_ detailsItems: inout [GameDetailsItemModel], resourcesFromGameDetails gameDetails: GameDetailsModel?) {
        guard let gameDetails = gameDetails else {
            return
        }
        self.appendToDetailsItems(&detailsItems, ifResourcesExists: gameDetails.reviews, itemType: .reviews)
        self.appendToDetailsItems(&detailsItems, ifResourcesExists: gameDetails.videos, itemType: .videos)
        self.appendToDetailsItems(&detailsItems, ifResourcesExists: gameDetails.images, itemType: .images)
    }

    private func appendToDetailsItems(_ detailsItems: inout [GameDetailsItemModel], ifResourcesExists resources: [Any]?, itemType: GameDetailsItems) {
        guard let resources = resources, resources.count > 0 else {
            return
        }
        detailsItems.append(GameDetailsItemModel(item: itemType, contentSize: resources.count))
    }

    func gameDetailsItem(forIndexPath indexPath: IndexPath) -> GameDetailsItemModel? {
        let gameDetailsItems = self.gameDetailsItems
        guard indexPath.row < gameDetailsItems.count else {
            return nil
        }
        return gameDetailsItems[indexPath.row]
    }

    // MARK: Download game details
    func downloadGameDetailsIfNeed(refresh: Bool = false) {
        guard refresh || dataState == .error || gameDetails == nil else {
            return
        }
        downloadGameDetails()
    }
    
    private func downloadGameDetails() {
        dataState = .loading

        gameDetailsDisposeBag = DisposeBag()
        giantBombClient.gameDetails(forGuid: game.guid)
            .subscribe({ [weak self] event in
                guard let self = self, !event.isCompleted else {
                    return
                }

                guard event.error == nil, let gameDetails = event.element?.1?.results else {
                    self.dataState = .error
                    return
                }

                self.gameDetailsVar.accept(gameDetails)
                self.dataState = .none
            }).disposed(by: gameDetailsDisposeBag)
    }
    
    func goToOverviewDetailsItem(_ detailsItem: GameDetailsItemModel, navigationController: UINavigationController?) {
        _ = appCoordinator?.transition(.push(onNavigationController: navigationController), scene: WebViewControllerSceneBuilder(barTitle: detailsItem.localizedName, html: game.description ?? ""))
    }

    func goToImagesDetailsItem(navigationController: UINavigationController?) {
        guard let images = gameDetails?.images else {
            return
        }
        _ = appCoordinator?.transition(.push(onNavigationController: navigationController), scene: GameImagesSceneBuilder(images: images))
    }
}
