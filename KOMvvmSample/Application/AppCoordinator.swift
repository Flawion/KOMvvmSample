//
//  AppCoordinator.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

protocol SceneBuilderProtocol {
    func createScene(withServiceLocator serviceLocator: ServiceLocator) -> UIViewController
}

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
    
    // MARK: Push new view controllers
    func push(scene: SceneBuilderProtocol, onNavigationController: UINavigationController?, animated: Bool = true) -> UIViewController? {
        let newSceneViewController = scene.createScene(withServiceLocator: serviceLocator)
        return push(viewController: newSceneViewController, onNavigationController: onNavigationController, animated: animated) ? newSceneViewController : nil
    }

    private func push(viewController: UIViewController, onNavigationController: UINavigationController?, animated: Bool = true) -> Bool {
        guard let onNavigationController = onNavigationController else {
            return false
        }
        onNavigationController.pushViewController(viewController, animated: animated)
        return true
    }
}
