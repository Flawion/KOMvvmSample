//
//  AppCoordinator.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOMvvmSampleLogic

/// Class that navigate between different scenes and contains all services in local instance of ServiceLocator.
final class AppCoordinator: BaseAppCoordinator {
    
    override func setWindowRootViewController() {
        guard let window = window else {
            return
        }
        window.rootViewController = createMainNavigationController()
    }
 
    override func registerViewControllers(builder: ScenesViewControllerBuilder) {
        builder.register(viewControllerType: GamesViewController.self, forType: .games)
        builder.register(viewControllerType: GameDetailsViewController.self, forType: .gameDetails)
        builder.register(viewControllerType: GamesFiltersViewController.self, forType: .gamesFilters)
        builder.register(viewControllerType: GameImagesViewController.self, forType: .gameImages)
        builder.register(viewControllerType: WebViewController.self, forType: .web)
        builder.register(viewControllerType: ImageViewerViewController.self, forType: .imageViewer)
    }
    
    private func createMainNavigationController() -> UINavigationController {
        let mainSceneViewController = createMainSceneViewController()
        let mainNavigationController = UINavigationController(rootViewController: mainSceneViewController)
        mainNavigationController.navigationBar.tintColor = UIColor.Theme.barTint
        mainNavigationController.navigationBar.backgroundColor = UIColor.Theme.barBackground
        return mainNavigationController
    }
}
