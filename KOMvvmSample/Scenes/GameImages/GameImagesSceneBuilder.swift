//
//  GameImagesSceneBuilder.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct GameImagesSceneBuilder: SceneBuilderProtocol {
    private let images: [ImageModel]

    init(images: [ImageModel]) {
        self.images = images
    }

    func createScene(withServiceLocator serviceLocator: ServiceLocator) -> UIViewController {
        let viewModel = GameImagesViewModel(images: images)
        return GameImagesViewController(viewModel: viewModel)
    }
}
