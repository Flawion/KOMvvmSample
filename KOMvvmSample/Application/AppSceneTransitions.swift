//
//  AppSceneTransitions.swift
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
