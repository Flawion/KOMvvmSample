//
//  BaseAppCoordinator.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOInject

// MARK: - BaseAppCoordinator
////// Entry app point, it must be overridden in UI part to make a bridge between Logic and UI.
open class BaseAppCoordinator: AppCoordinatorProtocol {
    // MARK: Variables
    private let iocContainer: KOIContainer
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
    public init() {
        self.iocContainer = KOIContainer()
        registerServices(register: iocContainer)
        regsiterViewModels(register: iocContainer)
        registerViewControllers(register: iocContainer)
    }
    
    init(iocContainer: KOIContainer) {
        self.iocContainer = iocContainer
        registerServices(register: iocContainer)
        regsiterViewModels(register: iocContainer)
        registerViewControllers(register: iocContainer)
    }
    
    func registerServices(register: KOIRegisterProtocol) {
        register.register(forType: GiantBombClientServiceProtocol.self, scope: .shared) { _ in
            return GiantBombClientService()
        }
        register.register(forType: DataStoreServiceProtocol.self, scope: .shared) { _ in
            return DataStoreService()
        }
    }
    
    func regsiterViewModels(register: KOIRegisterProtocol) {
        GamesViewModelRegister().register(register: iocContainer)
        GameDetailsViewModelRegister().register(register: iocContainer)
        GamesFiltersViewModelRegister().register(register: iocContainer)
        GameImagesViewModelRegister().register(register: iocContainer)
        WebViewModelRegister().register(register: iocContainer)
        ImageViewerViewModelRegister().register(register: iocContainer)
    }
    
    open func registerViewControllers(register: KOIRegisterProtocol) {
        fatalError("registerViewControllers - should be overriden")
    }
    
    // MARK: Actions
    public func initializeScene() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        setWindowRootViewController()
    }
    
    open func setWindowRootViewController() {
        fatalError("setWindowRootViewController - should be overriden")
    }
    
    public func createMainSceneViewController() -> UIViewController {
        guard let sceneViewController: GamesViewControllerProtocol = iocContainer.resolve(arg1: self as AppCoordinatorProtocol) else {
            fatalError("can't resolve")
        }
        return sceneViewController
    }
    
    public func openLink(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    public func transition(_ transtion: BaseSceneTransition, toScene scene: SceneResolverProtocol) -> Any? {
        return transition(transtion, toScenes: [scene])
    }
    
    public func transition(_ transtion: BaseSceneTransition, toScenes scenes: [SceneResolverProtocol]) -> Any? {
        var scenesViewControllers: [UIViewController] = []
        for scene in scenes {
            scenesViewControllers.append(scene.resolve(withAppCoordinator: self, resolver: iocContainer))
        }
        return transtion.transition(toScenesViewControllers: scenesViewControllers)
    }
}
