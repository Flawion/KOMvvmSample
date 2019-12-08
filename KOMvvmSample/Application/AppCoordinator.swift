//
//  AppCoordinator.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

protocol SceneBuilderProtocol {
    func createScene(withServiceLocator serviceLocator: ServiceLocator) -> UIViewController
}

/// Class that navigate between different scenes and contains all services in local instance of ServiceLocator.
final class AppCoordinator {
    // MARK: Variables
    static let shared = {
        return AppCoordinator()
    }()
    
    private let serviceLocator: ServiceLocator
    private var window: UIWindow?

    /// Blocking all user interaction on UIWindow can be used in animation
    var blockAllUserInteraction: Bool {
        get {
            return window?.isUserInteractionEnabled ?? false
        }
        set {
            window?.isUserInteractionEnabled = newValue
        }
    }
    
    // MARK: Initialization
    private init() {
        serviceLocator = ServiceLocator()
        registerServices()
    }

    private func registerServices() {
        serviceLocator.register(withBuilder: GiantBombClientServiceBuilder())
        serviceLocator.register(withBuilder: DataStoreServiceBuilder())
        serviceLocator.register(withBuilder: PlatformsServiceBuilder())
    }
    
    // MARK: Initialize first scene
    func initializeScene() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        createMainScene()
    }
    
    private func createMainScene() {
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

    private func createMainSceneViewController() -> UIViewController {
        return GamesSceneBuilder().createScene(withServiceLocator: serviceLocator)
    }

    // MARK: Actions
    func openLink(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func transition(_ transtion: BaseSceneTransition) -> Any? {
        return transtion.transition(serviceLocator: serviceLocator)
    }
}
