//
//  ImageViewerSceneResolver.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import KOInject

struct ImageViewerSceneResolver: SceneResolverProtocol {
    let image: ImageModel
    
    init(image: ImageModel) {
        self.image = image
    }
    
    func resolve(withAppCoordinator appCoordinator: AppCoordinatorProtocol, resolver: KOIResolverProtocol) -> UIViewController {
        guard let viewController: ImageViewerViewControllerProtocol = resolver.resolve(arg1: appCoordinator, arg2: image) else {
            fatalError(fatalErrorMessage)
        }
        return viewController
    }
}
