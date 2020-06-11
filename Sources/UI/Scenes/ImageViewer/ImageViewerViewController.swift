//
//  ImageViewerViewController.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class ImageViewerViewController: BaseViewController<ImageViewerViewModelProtocol> {
    private weak var imageViewerView: ImageViewerView!
    
    // MARK: View controller functions
    override func loadView() {
        let imageViewerView = ImageViewerView(controllerProtocol: self)
        view = imageViewerView
        self.imageViewerView = imageViewerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        initializeView()
        bindActions(toViewModel: viewModel)
        addRefreshButtonHandler()
    }
    
    private func initializeView() {
        prepareNavigationBar(withTitle: "image_viewer_bar_title".localized)
    }
    private func addRefreshButtonHandler() {
        (errorView as? ErrorView)?.refreshButtonClicked.asDriver().drive(onNext: { [weak self] in
            self?.imageViewerView.refreshImageData()
        }).disposed(by: disposeBag)
    }
    
    override func initializeLoadingView() -> BaseStateView {
        let imageViewerLoadingView = ImageViewerLoadingView()
        _ = view.addAutoLayoutSubview(imageViewerLoadingView)
        guard let imageUrl = viewModel.image.mediumUrl else {
            return imageViewerLoadingView
        }
        imageViewerLoadingView.placeholderImageView.setImageFade(url: imageUrl)
        return imageViewerLoadingView
    }
}

// MARK: - ImageViewerViewControllerProtocol
extension ImageViewerViewController: ImageViewerViewControllerProtocol {
    func turnOnPhotoMode() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func turnOffPhotoMode() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
