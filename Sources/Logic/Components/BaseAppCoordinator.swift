//
//  BaseAppCoordinator.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

protocol SceneBuilderProtocol {
    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol)) -> UIViewController
}

extension SceneBuilderProtocol {
    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol), viewModel: ViewModelProtocol, type: SceneTypes) -> UIViewController {
        guard let viewController = appCoordinator.getSceneViewController(forViewModel: viewModel, type: type) else {
            fatalError("can't get view controller")
        }
        return viewController
    }
}

protocol AppCoordinatorProtocol: NSObjectProtocol {
    var blockAllUserInteraction: Bool { get set }
    
    func initializeScene()
    func openLink(_ url: URL)
    func transition(_ transtion: BaseSceneTransition, scene: SceneBuilderProtocol) -> Any?
    func transition(_ transtion: BaseSceneTransition, scenes: [SceneBuilderProtocol]) -> Any?
}

protocol AppCoordinatorResouresProtocol: NSObjectProtocol {
    func getService<ReturnType>(type: ServiceTypes) -> ReturnType?
    func getSceneViewController(forViewModel viewModel: ViewModelProtocol, type: SceneTypes) -> ViewControllerProtocol?
}

// MARK: - BaseAppCoordinator
class BaseAppCoordinator: NSObject, AppCoordinatorProtocol {
    // MARK: Variables
    private let serviceLocator: ServiceLocator
    private let scenesViewControllerBuilder: ScenesViewControllerBuilder
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
        scenesViewControllerBuilder = ScenesViewControllerBuilder()
        super.init()
        registerServices(locator: serviceLocator)
        registerViewControllers(builder: scenesViewControllerBuilder)
    }
    
    func registerServices(locator: ServiceLocator) {
        locator.register(withBuilder: GiantBombClientServiceBuilder())
        locator.register(withBuilder: DataStoreServiceBuilder())
        locator.register(withBuilder: PlatformsServiceBuilder())
    }
    
    func registerViewControllers(builder: ScenesViewControllerBuilder) {
        fatalError("registerViewControllers - should be overriden")
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
        return GamesSceneBuilder().createScene(withAppCoordinator: self)
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
            scenesViewControllers.append(scene.createScene(withAppCoordinator: self))
        }
        return transtion.transition(toScenesViewControllers: scenesViewControllers)
    }
}

// MARK: - AppCoordinatorResouresProtocol
extension BaseAppCoordinator: AppCoordinatorResouresProtocol {
    func getService<ReturnType>(type: ServiceTypes) -> ReturnType? {
        return serviceLocator.get(type: type)
    }
    
    func getSceneViewController(forViewModel viewModel: ViewModelProtocol, type: SceneTypes) -> ViewControllerProtocol? {
        return scenesViewControllerBuilder.get(forViewModel: viewModel, type: type)
    }
}
