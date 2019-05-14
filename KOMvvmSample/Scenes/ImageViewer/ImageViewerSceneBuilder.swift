//
//  ImageViewerSceneBuilder.swift
//  KOMvvmSample
//
//  Created by Kuba Ostrowski on 14/05/2019.
//

import Foundation

final class ImageViewerSceneBuilder: SceneBuilderProtocol {
    private let image: ImageModel

    init(image: ImageModel) {
        self.image = image
    }

    func createScene(withServiceLocator serviceLocator: ServiceLocator) -> UIViewController {
        let viewModel = ImageViewerViewModel(image: image)
        return ImageViewerViewController(viewModel: viewModel)
    }
}
