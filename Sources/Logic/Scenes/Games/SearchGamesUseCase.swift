//
//  SearchGamesUseCase.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa

final class SearchGamesUseCase: BaseDataController {
    // MARK: Variables
    //private
    private var giantBombClient: GiantBombClientServiceProtocol!
    private var dataActionStateRelay: BehaviorRelay<DataActionStates> = BehaviorRelay<DataActionStates>(value: .none)
    private var raiseErrorSubject: PublishSubject<Error> = PublishSubject<Error>()
    
    private var gamesRelay: BehaviorRelay<[GameModel]> = BehaviorRelay<[GameModel]>(value: [])
    private var offset: Int = 0
    private var totalResultsCount: Int = 0
    
    private var searchDisposeBag: DisposeBag!
    
    //public
    private(set) var filters: [GamesFilters: String] = AppSettings.Games.defaultFilters
    
    var games: [GameModel] {
        return gamesRelay.value
    }
    
    var gamesDriver: Driver<[GameModel]> {
        return gamesRelay.asDriver()
    }
    
    var canDownloadMoreResults: Bool {
        return offset < totalResultsCount
    }
    
    init(giantBombClient: GiantBombClientServiceProtocol) {
        self.giantBombClient = giantBombClient
        super.init()
    }
    
    // MARK: Searching functions
    func searchMore() {
        guard canDownloadMoreResults else {
            return
        }
        search(offset: offset)
    }
    
    func searchIfNeed(force: Bool = false) {
        guard force || isNeedToSearch else {
            return
        }
        search()
    }
    
    private var isNeedToSearch: Bool {
        return dataActionState == .error || games.count <= 0
    }
    
    private func search(offset: Int = 0) {
        prepareForSearching(offset: offset)
        requestSearch(offset: offset)
    }
    
    private func prepareForSearching(offset: Int = 0) {
        searchDisposeBag = DisposeBag()
        dataActionState = isSearchingMore(offset: offset) ? .loadingMore : .loading
        clearDataIfNeed(offset: offset)
    }
    
    private func isSearchingMore(offset: Int = 0) -> Bool {
        return offset > 0
    }
    
    private func clearDataIfNeed(offset: Int) {
        guard !isSearchingMore(offset: offset) else {
            return
        }
        clearData()
    }
    
    private func clearData() {
        gamesRelay.accept([])
        offset = 0
        totalResultsCount = 0
    }
    
    private func requestSearch(offset: Int = 0) {
        giantBombClient.searchGames(offset: offset, limit: AppSettings.Games.limitPerRequest, filters: FiltersUtils().gamesFiltersString(fromFilters: filters), sorting: FiltersUtils().gamesSortingString(fromFilters: filters))
            .subscribe({ [weak self] event in
                guard let self = self, !event.isCompleted else {
                    return
                }
                
                if let error = event.error {
                    self.showSearch(error: error)
                    return
                }
                
                //adds new games
                if let data = event.element?.1, let newGames = data.results {
                    self.totalResultsCount = data.numberOfTotalResults
                    self.add(newGames: newGames)
                }
                self.checkIsGameListEmpty()
            }).disposed(by: searchDisposeBag)
    }
    
    private func showSearch(error: Error) {
        //if it's the first search block whole screen with refresh message
        if offset == 0 {
            dataActionState = .error
        } else { //else show message only
            raise(error: error)
            checkIsGameListEmpty()
        }
    }
    
    private func checkIsGameListEmpty() {
        dataActionState = gamesRelay.value.count > 0 ? .none : .empty
    }
    
    private func add(newGames: [GameModel]) {
        var refreshedGames = gamesRelay.value
        refreshedGames.append(contentsOf: newGames)
        gamesRelay.accept(refreshedGames)
        offset = refreshedGames.count
    }
    
    func game(atIndex index: Int) -> GameModel? {
        guard index < gamesRelay.value.count else {
            return nil
        }
        return gamesRelay.value[index]
    }
    
    // MARK: Change filters
    func change(filters: [GamesFilters: String?]) {
        guard update(filters: filters) else {
            return
        }
        searchIfNeed(force: true)
    }
    
    /// returns is need to refresh games
    private func update(filters: [GamesFilters: String?]) -> Bool {
        var updated: Bool = false
        for filter in filters {
            if update(filter: filter) {
                updated = true
            }
        }
        return updated
    }
    
    private func update(filter: (key: GamesFilters, value: String?)) -> Bool {
        let newValue = filter.value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if let currentFilter = self.filters[filter.key] {
            if currentFilter != newValue {
                changeFilterValue(withKey: filter.key, toValue: newValue)
                return true
            }
        } else if !newValue.isEmpty {
            self.filters[filter.key] = newValue
            return true
        }
        return false
    }
    
    private func changeFilterValue(withKey key: GamesFilters, toValue value: String) {
        guard !value.isEmpty else {
            self.filters.removeValue(forKey: key)
            return
        }
        self.filters[key] = value
    }
}
