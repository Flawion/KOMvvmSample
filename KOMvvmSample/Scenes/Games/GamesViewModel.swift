//
//  GamesViewModel.swift
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

import RxSwift
import RxCocoa

final class GamesViewModel: BaseViewModel {
    // MARK: Variables
    //private
    private var giantBombClient: GiantBombClientServiceProtocol!
    
    private var gamesOffset: Int = 0
    private var gamesTotalResults: Int = 0
    private var gamesVar: BehaviorRelay<[GameModel]> = BehaviorRelay<[GameModel]>(value: [])
    
    private var searchDisposeBag: DisposeBag!
    
    //public
    private(set) var gamesFilters: [GamesFilters: String] = AppSettings.Games.defaultFilters

    var gameObser: Observable<[GameModel]> {
        return gamesVar.asObservable()
    }
    
    var games: [GameModel] {
        return gamesVar.value
    }

    var canDownloadMoreResults: Bool {
        return gamesOffset < gamesTotalResults
    }

    init(giantBombClient: GiantBombClientServiceProtocol) {
        super.init()
        self.giantBombClient = giantBombClient
    }

    // MARK: Searching games functions
    func searchMoreGames() {
        guard canDownloadMoreResults else {
            return
        }
        searchGames(offset: gamesOffset)
    }
    
    func searchGamesIfNeed(forceRefresh: Bool = false) {
        guard forceRefresh || isNeedToSearchGames else {
            return
        }
        searchGames()
    }

    private var isNeedToSearchGames: Bool {
        return isDataStateError || gamesVar.value.count <= 0
    }
    
    private func searchGames(offset: Int = 0) {
        prepareForSearchingGames(offset: offset)
        requestSearchGames(offset: offset)
    }

    private func prepareForSearchingGames(offset: Int = 0) {
        searchDisposeBag = DisposeBag()
        dataState = isSearchingMoreGames(offset: offset) ? .loadingMore : .loading
        clearGamesDataIfNeed(offset: offset)
    }

    private func isSearchingMoreGames(offset: Int = 0) -> Bool {
        return offset > 0
    }

    private func clearGamesDataIfNeed(offset: Int) {
        guard !isSearchingMoreGames(offset: offset) else {
            return
        }
        clearGames()
    }

    private func clearGames() {
        gamesVar.accept([])
        gamesOffset = 0
        gamesTotalResults = 0
    }

    private func requestSearchGames(offset: Int = 0) {
        giantBombClient.searchGames(offset: offset, limit: AppSettings.Games.limitPerRequest, filters: Utils.shared.gamesFiltersString(fromFilters: gamesFilters), sorting: Utils.shared.gamesSortingString(fromFilters: gamesFilters))
            .subscribe({ [weak self] event in
                guard let self = self, !event.isCompleted else {
                    return
                }

                if let error = event.error {
                    self.showSearchError(error)
                    return
                }

                //adds new games
                if let data = event.element?.1, let newGames = data.results {
                    self.gamesTotalResults = data.numberOfTotalResults
                    self.addNewGames(newGames)
                }
                self.checkIsGameListEmpty()
            }).disposed(by: searchDisposeBag)
    }

    private func showSearchError(_ error: Error) {
        //if it's the first search block whole screen with refresh message
        if gamesOffset == 0 {
            dataState = .error
        } else { //else show message only
            raiseError(error)
            checkIsGameListEmpty()
        }
    }

    private func checkIsGameListEmpty() {
        dataState = gamesVar.value.count > 0 ? .none : .empty
    }

    private func addNewGames(_ newGames: [GameModel]) {
        var refreshedGames = gamesVar.value
        refreshedGames.append(contentsOf: newGames)
        gamesVar.accept(refreshedGames)
        gamesOffset = refreshedGames.count
    }

    func game(atIndexPath indexPath: IndexPath) -> GameModel? {
        guard indexPath.row < gamesVar.value.count else {
            return nil
        }
        return gamesVar.value[indexPath.row]
    }

    // MARK: Change game filters
    func changeGameFilters(_ gameFilters: [GamesFilters: String?]) {
        guard updateGamesFilters(gameFilters) else {
            return
        }
        searchGamesIfNeed(forceRefresh: true)
    }

    /// returns is need to refresh games
    private func updateGamesFilters(_ gameFilters: [GamesFilters: String?]) -> Bool {
        var updated: Bool = false
        for gameFilter in gameFilters {
            if updateGameFilter(gameFilter) {
                updated = true
            }
        }
        return updated
    }

    private func updateGameFilter(_ gameFilter: (key: GamesFilters, value: String?)) -> Bool {
        let newValue = gameFilter.value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if let currentFilter = self.gamesFilters[gameFilter.key] {
            if currentFilter != newValue {
                changeGameFilterValue(withKey: gameFilter.key, toValue: newValue)
                return true
            }
        } else if !newValue.isEmpty {
            self.gamesFilters[gameFilter.key] = newValue
            return true
        }
        return false
    }

    private func changeGameFilterValue(withKey key: GamesFilters, toValue value: String) {
        if value.isEmpty {
            self.gamesFilters.removeValue(forKey: key)
        } else {
            self.gamesFilters[key] = value
        }
    }
}
