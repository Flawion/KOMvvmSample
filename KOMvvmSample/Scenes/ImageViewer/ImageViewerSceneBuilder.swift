//
//  ImageViewerSceneBuilder.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct ImageViewerSceneBuilder: SceneBuilderProtocol {
    private let image: ImageModel

    init(image: ImageModel) {
        self.image = image
    }

    func createScene(withServiceLocator serviceLocator: ServiceLocator) -> UIViewController {
        let viewModel = ImageViewerViewModel(image: image)
        return ImageViewerViewController(viewModel: viewModel)
    }
}
