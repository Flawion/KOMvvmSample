//
//  GamesViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import RxSwift
import RxCocoa

final class GamesViewModel: BaseViewModel {
    private let searchGamesUseCase: SearchGamesUseCase
    
    init(appCoordinator: AppCoordinatorProtocol, searchGamesUseCase: SearchGamesUseCase) {
        self.searchGamesUseCase = searchGamesUseCase
        super.init(appCoordinator: appCoordinator)
        forward(dataControllerState: searchGamesUseCase)
    }
}

// MARK: GamesViewModelProtocol
extension GamesViewModel: GamesViewModelProtocol {
    
    var isApiKeyValid: Bool {
        return !AppSettings.Api.key.isEmpty
    }
    
    var gamesDriver: Driver<[GameModel]> {
        return searchGamesUseCase.gamesDriver
    }
    
    var games: [GameModel] {
        return searchGamesUseCase.games
    }
    
    var filters: [GamesFilters: String] {
        return searchGamesUseCase.filters
    }
    
    var canDownloadMoreResults: Bool {
        return searchGamesUseCase.canDownloadMoreResults
    }
    
    // MARK: Searching games functions
    func searchMore() {
        searchGamesUseCase.searchMore()
    }
    
    func searchIfNeed(force: Bool = false) {
        searchGamesUseCase.searchIfNeed(force: force)
    }
    
    func game(atIndex index: Int) -> GameModel? {
        return searchGamesUseCase.game(atIndex: index)
    }
    
    // MARK: Change game filters
    func change(filters: [GamesFilters: String?]) {
        searchGamesUseCase.change(filters: filters)
    }
    
    // MARK: Navigation
    func goToGameDetail(_ game: GameModel, navigationController: UINavigationController?) {
        _ = appCoordinator?.transition(.push(onNavigationController: navigationController), toScene: GameDetailsSceneResolver(game: game))
    }
    
    func goToGamesFilter(navigationController: UINavigationController?) {
        guard let viewControllerProtocol = appCoordinator?.transition(.push(onNavigationController: navigationController), toScene: GamesFiltersSceneResolver(currentFilters: filters)) as? GamesFiltersViewControllerProtocol else {
            fatalError("cast failed GamesFiltersViewControllerProtocol")
        }
        viewControllerProtocol.viewModel.savedFiltersObservable.subscribe(onNext: { [weak self] savedFilters in
            self?.change(filters: savedFilters)
        }).disposed(by: viewControllerProtocol.viewModel.disposeBag)
    }
}
