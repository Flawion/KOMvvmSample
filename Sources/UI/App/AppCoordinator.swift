//
//  AppCoordinator.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOInject
import KOMvvmSampleLogic

/// Class that navigate between different scenes and contains all services in local instance of ServiceLocator.
final class AppCoordinator: BaseAppCoordinator {
    
    override func setWindowRootViewController() {
        guard let window = window else {
            return
        }
        window.rootViewController = createMainNavigationController()
    }
 
    override func registerViewControllers(register: KOIRegisterProtocol) {
        GamesViewControllerRegister().register(register: register)
        GameDetailsViewControllerRegister().register(register: register)
        GamesFiltersViewControllerRegister().register(register: register)
        GameImagesViewControllerRegister().register(register: register)
        WebViewControllerRegister().register(register: register)
        ImageViewerViewControllerRegister().register(register: register)
    }
    
    private func createMainNavigationController() -> UINavigationController {
        let mainSceneViewController = createMainSceneViewController()
        let mainNavigationController = NavigationController(rootViewController: mainSceneViewController)
        mainNavigationController.navigationBar.tintColor = UIColor.Theme.barTint
        mainNavigationController.navigationBar.backgroundColor = UIColor.Theme.barBackground
        return mainNavigationController
    }
}
