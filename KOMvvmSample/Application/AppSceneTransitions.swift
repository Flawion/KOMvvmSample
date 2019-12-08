//
//  AppSceneTransitions.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

// MARK: - Scene transition
class BaseSceneTransition {
    func transition(serviceLocator: ServiceLocator) -> Any? {
        fatalError("to override")
    }
}

extension BaseSceneTransition {
    static func push(scene: SceneBuilderProtocol, onNavigationController: UINavigationController?, animated: Bool = true) -> BaseSceneTransition {
        return PushSceneTransition(scene: scene, onNavigationController: onNavigationController, animated: animated)
    }

    static func set(scenes: [SceneBuilderProtocol], onNavigationController: UINavigationController?, animated: Bool = true) -> BaseSceneTransition {
        return SetScenesTransition(scenes: scenes, onNavigationController: onNavigationController, animated: animated)
    }

    static func present(scene: SceneBuilderProtocol, onViewController: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) -> BaseSceneTransition {
        return PresentSceneTransition(scene: scene, onViewController: onViewController, animated: animated, completion: completion)
    }
}

final class PushSceneTransition: BaseSceneTransition {
    private let scene: SceneBuilderProtocol
    private let animated: Bool
    private weak var navigationController: UINavigationController?
    
    init(scene: SceneBuilderProtocol, onNavigationController: UINavigationController?, animated: Bool = true) {
        self.scene = scene
        self.navigationController = onNavigationController
        self.animated = animated
    }
    
    override func transition(serviceLocator: ServiceLocator) -> Any? {
        let sceneViewController = scene.createScene(withServiceLocator: serviceLocator)
        navigationController?.pushViewController(sceneViewController, animated: animated)
        return sceneViewController
    }
}

final class SetScenesTransition: BaseSceneTransition {
    private let scenes: [SceneBuilderProtocol]
    private let animated: Bool
    private weak var navigationController: UINavigationController?

    init(scenes: [SceneBuilderProtocol], onNavigationController: UINavigationController?, animated: Bool = true) {
        self.scenes = scenes
        self.navigationController = onNavigationController
        self.animated = animated
    }

    override func transition(serviceLocator: ServiceLocator) -> Any? {
        var scenesViewControllers: [UIViewController] = []
        for scene in scenes {
            scenesViewControllers.append(scene.createScene(withServiceLocator: serviceLocator))
        }
        navigationController?.setViewControllers(scenesViewControllers, animated: animated)
        return scenesViewControllers
    }
}

final class PresentSceneTransition: BaseSceneTransition {
    private let scene: SceneBuilderProtocol
    private let animated: Bool
    private let completion: (() -> Void)?
    private weak var presentingViewController: UIViewController?
   
    init(scene: SceneBuilderProtocol, onViewController: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.scene = scene
        self.animated = animated
        self.presentingViewController = onViewController
        self.completion = completion
    }
    
    override func transition(serviceLocator: ServiceLocator) -> Any? {
        let sceneViewController = scene.createScene(withServiceLocator: serviceLocator)
        presentingViewController?.present(sceneViewController, animated: animated, completion: completion)
        return sceneViewController
    }
}
