//
//  BaseAppCoordinator.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

// MARK: - BaseAppCoordinator
////// Entry app point, it must be overridden in UI part to make a bridge between Logic and UI.
open class BaseAppCoordinator: NSObject, AppCoordinatorProtocol {
    // MARK: Variables
    private let serviceLocator: ServiceLocator
    private let scenesViewControllerBuilder: ScenesViewControllerBuilder
    public private(set) var window: UIWindow?
    
    /// Blocking all user interaction on UIWindow can be used in animation
    public var isUserInteractionEnabled: Bool {
        get {
            return window?.isUserInteractionEnabled ?? false
        }
        set {
            window?.isUserInteractionEnabled = newValue
        }
    }
    
    // MARK: Initialization
    public override init() {
        serviceLocator = ServiceLocator()
        scenesViewControllerBuilder = ScenesViewControllerBuilder()
        super.init()
        registerServices(locator: serviceLocator)
        registerViewControllers(builder: scenesViewControllerBuilder)
    }
    
    func registerServices(locator: ServiceLocator) {
        locator.register(withBuilder: GiantBombClientServiceBuilder())
        locator.register(withBuilder: DataStoreServiceBuilder())
    }
    
    open func registerViewControllers(builder: ScenesViewControllerBuilder) {
        fatalError("registerViewControllers - should be overriden")
    }
    
    // MARK: Actions
    public func initializeScene() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        createWindowRootViewController()
    }
    
    open func createWindowRootViewController() {
        fatalError("createWindowRootViewController - should be overriden")
    }
    
    public func createMainSceneViewController() -> UIViewController {
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
