//
//  GamesSceneBuilder.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

struct GamesSceneBuilder: SceneBuilderProtocol {
    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol)) -> UIViewController {
        guard let giantBombClient: GiantBombClientServiceProtocol = appCoordinator.getService(type: .giantBombApiClient) else {
            fatalError("GamesSceneBuilder can't get giantBombApiClient service")
        }
        let searchGamesUseCase = SearchGamesUseCase(giantBombClient: giantBombClient)
        let viewModel = GamesViewModel(appCoordinator: appCoordinator, searchGamesUseCase: searchGamesUseCase)
        return createScene(withAppCoordinator: appCoordinator, viewModel: viewModel, type: .games)
    }
}
