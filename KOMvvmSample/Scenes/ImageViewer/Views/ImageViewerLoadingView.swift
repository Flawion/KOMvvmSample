//
//  ImageViewerLoadingView.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

final class ImageViewerLoadingView: BaseStateView {
    private(set) weak var placeholderImageView: UIImageView!
    private weak var loadingView: LoadingView!
    
    override func createView() {
        initializePlaceholderImage()
        initializeLoadingView()
    }

    private func initializePlaceholderImage() {
        let placeholderImageView = UIImageView()
        placeholderImageView.contentMode = .scaleAspectFit
        _ = addAutoLayoutSubview(placeholderImageView)
        self.placeholderImageView = placeholderImageView
    }

    private func initializeLoadingView() {
        let loadingView = LoadingView()
        loadingView.backgroundColor = UIColor.Theme.imageViewerLoadingBackground
        _ = addAutoLayoutSubview(loadingView)
        self.loadingView = loadingView
    }

    override func startActive() {
        super.startActive()
        loadingView.isActive = true
    }
    
    override func stopActive() {
        super.stopActive()
        loadingView.isActive = false
    }
}
