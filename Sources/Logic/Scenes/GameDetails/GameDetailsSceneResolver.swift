//
//  GameDetailsSceneResolver.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOInject

struct GameDetailsSceneResolver: SceneResolverProtocol {
    let game: GameModel
    
    init(game: GameModel) {
        self.game = game
    }
    
    func resolve(withAppCoordinator appCoordinator: AppCoordinatorProtocol, resolver: KOIResolverProtocol) -> UIViewController {
        guard let viewController: GameDetailsViewControllerProtocol = resolver.resolve(arg1: appCoordinator, arg2: game) else {
            fatalError(fatalErrorMessage)
        }
        return viewController
    }
}
