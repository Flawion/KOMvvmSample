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

    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol)) -> UIViewController {
        guard let giantBombClient: GiantBombClientServiceProtocol = appCoordinator.getService(type: .giantBombApiClient) else {
            fatalError("GameDetailsSceneBuilder can't get giantBombApiClient service")
        }
        let gameDetailsUseCase = GameDetailsUseCase(game: game, giantBombClient: giantBombClient)
        let viewModel = GameDetailsViewModel(appCoordinator: appCoordinator, gameDetailsUseCase: gameDetailsUseCase)
        return createScene(withAppCoordinator: appCoordinator, viewModel: viewModel, type: .gameDetails)
    }
}
