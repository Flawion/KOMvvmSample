//
//  GameImagesSceneBuilder.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

struct GameImagesSceneBuilder: SceneBuilderProtocol {
    private let images: [ImageModel]
    
    init(images: [ImageModel]) {
        self.images = images
    }
    
    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol)) -> UIViewController {
        let viewModel = GameImagesViewModel(appCoordinator: appCoordinator, images: images)
        return createScene(withAppCoordinator: appCoordinator, viewModel: viewModel, type: .gameImages)
    }
}
