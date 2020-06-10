//
//  GameDetailsSceneBuilder.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct GameDetailsSceneBuilder: SceneBuilderProtocol {
    private let game: GameModel

    init(game: GameModel) {
        self.game = game
    }

    func createScene(withAppCoordinator appCoordinator: AppCoordinatorProtocol, serviceLocator: ServiceLocator) -> UIViewController {
        guard let giantBombClient: GiantBombClientServiceProtocol = serviceLocator.get(type: .giantBombApiClient) else {
            fatalError("GameDetailsSceneBuilder can't get giantBombApiClient service")
        }
        let viewModel = GameDetailsViewModel(appCoordinator: appCoordinator, giantBombClient: giantBombClient, game: game)
        return GameDetailsViewController(viewModel: viewModel)
    }
}
