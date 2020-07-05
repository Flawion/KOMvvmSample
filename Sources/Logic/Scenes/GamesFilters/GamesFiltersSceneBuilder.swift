//
//  GamesFiltersSceneBuilder.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct GamesFiltersSceneBuilder: SceneBuilderProtocol {
    private let currentFilters: [GamesFilters: String]

    init(currentFilters: [GamesFilters: String]) {
        self.currentFilters = currentFilters
    }

    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol)) -> UIViewController {
        guard let giantBombClient: GiantBombClientServiceProtocol = appCoordinator.getService(type: .giantBombApiClient), let dataStore: DataStoreServiceProtocol = appCoordinator.getService(type: .dataStore) else {
            fatalError("GamesFiltersSceneBuilder can't get platformsService service")
        }
        let platformsUseCase = PlatformsUseCase(giantBombClient: giantBombClient, dataStore: dataStore)
        let viewModel = GamesFiltersViewModel(appCoordinator: appCoordinator, platformsUseCase: platformsUseCase, currentFilters: currentFilters)
        return createScene(withAppCoordinator: appCoordinator, viewModel: viewModel, type: .gamesFilters)
    }
}
