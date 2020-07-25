//
//  BaseSceneTransition.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

class BaseSceneTransition {
    func transition(toScenesViewControllers scenesViewControllers: [UIViewController]) -> Any? {
        fatalError("to override")
    }
}

// MARK: - Scene transition
extension BaseSceneTransition {
    static func push(onNavigationController: UINavigationController?, animated: Bool = true) -> BaseSceneTransition {
        return PushSceneTransition(onNavigationController: onNavigationController, animated: animated)
    }

    static func set(onNavigationController: UINavigationController?, animated: Bool = true) -> BaseSceneTransition {
        return SetScenesTransition(onNavigationController: onNavigationController, animated: animated)
    }

    static func present(onViewController: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) -> BaseSceneTransition {
        return PresentSceneTransition(onViewController: onViewController, animated: animated, completion: completion)
    }
}

final class PushSceneTransition: BaseSceneTransition {
    private let animated: Bool
    private weak var navigationController: UINavigationController?
    
    init(onNavigationController: UINavigationController?, animated: Bool = true) {
        self.navigationController = onNavigationController
        self.animated = animated
    }
    
    override func transition(toScenesViewControllers scenesViewControllers: [UIViewController]) -> Any? {
        guard let scene = scenesViewControllers.first else {
            fatalError("PushSceneTransition can't get scene")
        }
        navigationController?.pushViewController(scene, animated: animated)
        return scene
    }
}

final class SetScenesTransition: BaseSceneTransition {
    private let animated: Bool
    private weak var navigationController: UINavigationController?

    init(onNavigationController: UINavigationController?, animated: Bool = true) {
        self.navigationController = onNavigationController
        self.animated = animated
    }
    
    override func transition(toScenesViewControllers scenesViewControllers: [UIViewController]) -> Any? {
        navigationController?.setViewControllers(scenesViewControllers, animated: animated)
        return scenesViewControllers
    }
}

final class PresentSceneTransition: BaseSceneTransition {
    private let animated: Bool
    private let completion: (() -> Void)?
    private weak var presentingViewController: UIViewController?
   
    init(onViewController: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.animated = animated
        self.presentingViewController = onViewController
        self.completion = completion
    }
    
    override func transition(toScenesViewControllers scenesViewControllers: [UIViewController]) -> Any? {
        guard let scene = scenesViewControllers.first else {
            fatalError("PushSceneTransition can't get scene")
        }
        presentingViewController?.present(scene, animated: animated, completion: completion)
        return scene
    }
}
