//
//  BaseAppCoordinator.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

protocol SceneBuilderProtocol {
    func createScene(withAppCoordinator appCoordinator: AppCoordinatorProtocol, serviceLocator: ServiceLocator) -> UIViewController
}

protocol AppCoordinatorProtocol: NSObjectProtocol {
    var blockAllUserInteraction: Bool { get set }
    
    func initializeScene()
    func openLink(_ url: URL)
    func transition(_ transtion: BaseSceneTransition, scene: SceneBuilderProtocol) -> Any?
    func transition(_ transtion: BaseSceneTransition, scenes: [SceneBuilderProtocol]) -> Any?
}

class BaseAppCoordinator: NSObject, AppCoordinatorProtocol {
    // MARK: Variables
    private let serviceLocator: ServiceLocator
    private(set) var window: UIWindow?
    
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
    override init() {
        serviceLocator = ServiceLocator()
        super.init()
        registerServices()
    }
    
    func registerServices() {
        serviceLocator.register(withBuilder: GiantBombClientServiceBuilder())
        serviceLocator.register(withBuilder: DataStoreServiceBuilder())
        serviceLocator.register(withBuilder: PlatformsServiceBuilder())
    }
    
    // MARK: Actions
    func initializeScene() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        createMainScene()
    }
    
    func createMainScene() {
        fatalError("createMainScene - should be overriden")
    }
    
    func createMainSceneViewController() -> UIViewController {
        return GamesSceneBuilder().createScene(withAppCoordinator: self, serviceLocator: serviceLocator)
    }
    
    func openLink(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func transition(_ transtion: BaseSceneTransition, scene: SceneBuilderProtocol) -> Any? {
        return transition(transtion, scenes: [scene])
    }
    
    func transition(_ transtion: BaseSceneTransition, scenes: [SceneBuilderProtocol]) -> Any? {
        var scenesViewControllers: [UIViewController] = []
        for scene in scenes {
            scenesViewControllers.append(scene.createScene(withAppCoordinator: self, serviceLocator: serviceLocator))
        }
        return transtion.transition(toScenesViewControllers: scenesViewControllers)
    }
}
