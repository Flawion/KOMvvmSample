//
//  GamesFiltersSceneResolver.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOInject

struct GamesFiltersSceneResolver: SceneResolverProtocol {
    let currentFilters: [GamesFilters: String]
    
    init(currentFilters: [GamesFilters: String]) {
        self.currentFilters = currentFilters
    }
    
    func resolve(withAppCoordinator appCoordinator: AppCoordinatorProtocol, resolver: KOIResolverProtocol) -> UIViewController {
        guard let viewController: GamesFiltersViewControllerProtocol = resolver.resolve(arg1: appCoordinator, arg2: currentFilters) else {
            fatalError(fatalErrorMessage)
        }
        return viewController
    }
}
