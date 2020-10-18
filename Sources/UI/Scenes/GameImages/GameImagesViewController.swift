//
//  GameImagesViewController.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOMvvmSampleLogic

final class GameImagesViewController: BaseViewController<GameImagesViewModelProtocol> {
    // MARK: Variables
    private weak var gameImagesView: GameImagesView!

    // MARK: View controller functions
    override func loadView() {
        let gameImagesView = GameImagesView(controllerProtocol: self)
        view = gameImagesView
        self.gameImagesView = gameImagesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        prepareNavigationBar(withTitle: "game_images_bar_title".localized)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.gameImagesView.invalidateCollectionLayout()
        }, completion: nil)
    }
}

extension GameImagesViewController: GameImagesViewControllerProtocol {
    func goToImageViewer(forImage image: ImageModel) {
        viewModel.goToImageViewer(forImage: image, navigationController: navigationController)
    }
}
