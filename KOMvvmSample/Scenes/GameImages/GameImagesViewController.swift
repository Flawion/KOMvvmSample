//
//  GameImagesViewController.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class GameImagesViewController: BaseViewController {
    // MARK: Variables
    private weak var gameImagesView: GameImagesView!

    let viewModel: GameImagesViewModel

    // MARK: Initializations
    init(viewModel: GameImagesViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
}

extension GameImagesViewController: GameImagesViewControllerProtocol {
    func goToImageViewer(forImage image: ImageModel) {
        viewModel.goToImageViewer(forImage: image, navigationController: navigationController)
    }
}
