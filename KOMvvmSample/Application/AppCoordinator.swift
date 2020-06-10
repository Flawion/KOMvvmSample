//
//  AppCoordinator.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

/// Class that navigate between different scenes and contains all services in local instance of ServiceLocator.
final class AppCoordinator: BaseAppCoordinator {
    
    override func createMainScene() {
        guard let window = window else {
            return
        }
        window.rootViewController = createMainNavigationController()
    }
    
    private func createMainNavigationController() -> UINavigationController {
        let mainNavigationController = UINavigationController(rootViewController: createMainSceneViewController())
        mainNavigationController.navigationBar.tintColor = UIColor.Theme.barTint
        mainNavigationController.navigationBar.backgroundColor = UIColor.Theme.barBackground
        return mainNavigationController
    }
}
