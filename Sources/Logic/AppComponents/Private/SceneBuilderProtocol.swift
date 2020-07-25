//
//  SceneBuilderProtocol.swift
//  KOMvvmSampleLogic
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
