//
//  MockedViewController.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

@testable import KOMvvmSampleLogic

final class MockedViewController<ViewModelProtocol>: UIViewController, KOMvvmSampleLogic.ViewControllerProtocol {
    let viewModel: ViewModelProtocol
      
    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MockedViewController: GamesViewControllerProtocol where ViewModelProtocol == GamesViewModelProtocol {
}

extension MockedViewController: GameDetailsViewControllerProtocol where ViewModelProtocol == GameDetailsViewModelProtocol {
}

extension MockedViewController: GamesFiltersViewControllerProtocol where ViewModelProtocol == GamesFiltersViewModelProtocol {
}

extension MockedViewController: GameImagesViewControllerProtocol where ViewModelProtocol == GameImagesViewModelProtocol {
}

extension MockedViewController: WebViewControllerProtocol where ViewModelProtocol == WebViewModelProtocol {
}

extension MockedViewController: ImageViewerViewControllerProtocol where ViewModelProtocol == ImageViewerViewModelProtocol {
}
