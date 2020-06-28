//
//  GameDetailsUseCase.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa

final class GameDetailsUseCase: BaseDataController {
    // MARK: Variables
    // private
    private var giantBombClient: GiantBombClientServiceProtocol!
    
    private let gameRelay: BehaviorRelay<GameModel>
    private let gameDetailsRelay: BehaviorRelay<GameDetailsModel?> = BehaviorRelay<GameDetailsModel?>(value: nil)
    private let gameDetailsItemsRelay: BehaviorRelay<[GameDetailsItemModel]> = BehaviorRelay<[GameDetailsItemModel]>(value: [])
    
    private var gameDetailsDisposeBag: DisposeBag!
    private let disposeBag: DisposeBag = DisposeBag()
    
    // public
    var gameDriver: Driver<GameModel> {
        return gameRelay.asDriver()
    }
    
    var game: GameModel {
        return gameRelay.value
    }
    
    var gameDetails: GameDetailsModel? {
        return gameDetailsRelay.value
    }
    
    var gameDetailsDriver: Driver<GameDetailsModel?> {
        return gameDetailsRelay.asDriver()
    }
    
    var gameDetailsItems: [GameDetailsItemModel] {
        return gameDetailsItemsRelay.value
    }
    
    var gameDetailsItemsDriver: Driver<[GameDetailsItemModel]> {
        return gameDetailsItemsRelay.asDriver()
    }
    
    init(game: GameModel, giantBombClient: GiantBombClientServiceProtocol) {
        self.giantBombClient = giantBombClient
        gameRelay = BehaviorRelay<GameModel>(value: game)
        super.init()
        generateGameDetailItems()
    }
    
    private func generateGameDetailItems() {
        Observable<[GameDetailsItemModel]>.combineLatest(gameRelay.asObservable(), gameDetailsRelay.asObservable()) { [weak self] (game, gameDetails) -> [GameDetailsItemModel] in
            var detailsItems: [GameDetailsItemModel] = []
            
            guard let self = self else {
                return detailsItems
            }
            
            self.appendOverviewToDetailsItems(&detailsItems, ifDescriptionNotEmpty: game.description)
            self.appendToDetailsItems(&detailsItems, resourcesFromGameDetails: gameDetails)
            return detailsItems
        }.bind(to: gameDetailsItemsRelay).disposed(by: disposeBag)
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
    
    func gameDetailsItem(forIndex index: Int) -> GameDetailsItemModel? {
        let gameDetailsItems = self.gameDetailsItems
        guard index < gameDetailsItems.count else {
            return nil
        }
        return gameDetailsItems[index]
    }
    
    // MARK: Download details
    func downloadIfNeed(force: Bool = false) {
        guard force || dataActionState == .error || gameDetails == nil else {
            return
        }
        download()
    }
    
    private func download() {
        dataActionState = .loading
        
        gameDetailsDisposeBag = DisposeBag()
        giantBombClient.gameDetails(forGuid: game.guid)
            .subscribe({ [weak self] event in
                guard let self = self, !event.isCompleted else {
                    return
                }
                
                guard event.error == nil, let gameDetails = event.element?.1?.results else {
                    self.dataActionState = .error
                    return
                }
                
                self.gameDetailsRelay.accept(gameDetails)
                self.dataActionState = .none
            }).disposed(by: gameDetailsDisposeBag)
    }
}
