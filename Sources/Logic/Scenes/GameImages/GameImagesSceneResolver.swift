//
//  GameImagesSceneResolver.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOInject

struct GameImagesSceneResolver: SceneResolverProtocol {
    let images: [ImageModel]
    
    init(images: [ImageModel]) {
        self.images = images
    }
    
    func resolve(withAppCoordinator appCoordinator: AppCoordinatorProtocol, resolver: KOIResolverProtocol) -> UIViewController {
        guard let viewController: GameImagesViewControllerProtocol = resolver.resolve(arg1: appCoordinator, arg2: images) else {
            fatalError(fatalErrorMessage)
        }
        return viewController
    }
}
