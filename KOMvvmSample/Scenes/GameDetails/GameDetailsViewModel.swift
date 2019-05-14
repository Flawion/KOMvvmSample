//
//  GameDetailsViewModel.swift
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
    init(giantBombClient: GiantBombClientServiceProtocol, game: GameModel) {
        self.giantBombClient = giantBombClient
        gameVar = BehaviorRelay<GameModel>(value: game)
        super.init()

        generateGameDetailItems()
    }

    // MARK: Game details items
    func gameDetailsItem(forIndexPath indexPath: IndexPath) -> GameDetailsItemModel? {
        let gameDetailsItems = self.gameDetailsItems
        guard indexPath.row < gameDetailsItems.count else {
            return nil
        }
        return gameDetailsItems[indexPath.row]
    }
    
    private func generateGameDetailItems() {
        Observable<[GameDetailsItemModel]>.combineLatest(gameVar.asObservable(), gameDetailsVar.asObservable()) { [weak self] (game, gameDetails) -> [GameDetailsItemModel] in
            var detailsItems: [GameDetailsItemModel] = []
            if !(game.description?.isEmpty ?? true) {
                detailsItems.append(GameDetailsItemModel(item: .overview, contentSize: 0))
            }

            guard let gameDetails = gameDetails, let self = self else {
                return detailsItems
            }
            
            self.appendDetailsItem(&detailsItems, ifResourcesExists: gameDetails.reviews, itemType: .reviews)
            self.appendDetailsItem(&detailsItems, ifResourcesExists: gameDetails.videos, itemType: .videos)
            self.appendDetailsItem(&detailsItems, ifResourcesExists: gameDetails.images, itemType: .images)

            return detailsItems
        }.bind(to: gameDetailsItemsVar).disposed(by: disposeBag)
    }
    
    private func appendDetailsItem(_ detailsItems: inout [GameDetailsItemModel], ifResourcesExists resources: [AnyObject]?, itemType: GameDetailsItems) {
        guard let resources = resources, resources.count > 0 else {
            return
        }
        detailsItems.append(GameDetailsItemModel(item: itemType, contentSize: resources.count))
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

                //checks if error appears
                guard event.error == nil, let gameDetails = event.element?.1?.results else {
                    self.dataState = .error
                    return
                }

                //gets game details
                self.gameDetailsVar.accept(gameDetails)
                self.dataState = .none
            }).disposed(by: gameDetailsDisposeBag)
    }
}
