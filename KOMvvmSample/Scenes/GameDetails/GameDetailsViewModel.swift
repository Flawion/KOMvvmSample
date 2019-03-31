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
    init(game: GameModel) {
        gameVar = BehaviorRelay<GameModel>(value: game)
        super.init()

        generateGameDetailItems()
    }

    private func generateGameDetailItems() {
        Observable<[GameDetailsItemModel]>.combineLatest(gameVar.asObservable(), gameDetailsVar.asObservable()) { (game, gameDetails) -> [GameDetailsItemModel] in
            var detailsItems: [GameDetailsItemModel] = []
            if !(game.description?.isEmpty ?? true) {
                detailsItems.append(GameDetailsItemModel(item: .overview, contentSize: 0))
            }

            guard let gameDetails = gameDetails else {
                return detailsItems
            }
            if let reviews = gameDetails.reviews, reviews.count > 0 {
                detailsItems.append(GameDetailsItemModel(item: .reviews, contentSize: reviews.count))
            }
            if let videos = gameDetails.videos, videos.count > 0 {
                detailsItems.append(GameDetailsItemModel(item: .videos, contentSize: videos.count))
            }
            if let images = gameDetails.images, images.count > 0 {
                detailsItems.append(GameDetailsItemModel(item: .images, contentSize: images.count))
            }

            return detailsItems
        }.bind(to: gameDetailsItemsVar).disposed(by: disposeBag)
    }

    private func downloadGameDetails() {
        dataState = .loading

        gameDetailsDisposeBag = DisposeBag()
        ApiClientService.giantBomb.gameDetails(forGuid: game.guid)
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

    // MARK: Public functions
    func gameDetailsItem(forIndexPath indexPath: IndexPath) -> GameDetailsItemModel? {
        let gameDetailsItems = self.gameDetailsItems
        guard indexPath.row < gameDetailsItems.count else {
            return nil
        }
        return gameDetailsItems[indexPath.row]
    }

    func downloadGameDetailsIfNeed(refresh: Bool = false) {
        guard refresh || dataState == .error || gameDetails == nil else {
            return
        }
        downloadGameDetails()
    }
}
