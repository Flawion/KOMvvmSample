//
//  GamesSceneBuilder.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct GamesSceneBuilder: SceneBuilderProtocol {
    func createScene(withAppCoordinator appCoordinator: AppCoordinatorProtocol, serviceLocator: ServiceLocator) -> UIViewController {
        guard let giantBombClient: GiantBombClientServiceProtocol = serviceLocator.get(type: .giantBombApiClient) else {
            fatalError("GamesSceneBuilder can't get giantBombApiClient service")
        }
        let viewModel = GamesViewModel(appCoordinator: appCoordinator, giantBombClient: giantBombClient)
        return GamesViewController(viewModel: viewModel)
    }
}
