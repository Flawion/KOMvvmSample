//
//  GamesSceneResolver.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOInject

struct GamesSceneResolver: SceneResolverProtocol {
    func resolve(withAppCoordinator appCoordinator: AppCoordinatorProtocol, resolver: KOIResolverProtocol) -> UIViewController {
        guard let viewController: GamesViewControllerProtocol = resolver.resolve(arg1: appCoordinator) else {
            fatalError(fatalErrorMessage)
        }
        return viewController
    }
}
