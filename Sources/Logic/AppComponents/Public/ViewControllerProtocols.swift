//
//  ViewControllerProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

public protocol ViewControllerProtocol: UIViewController {
}

public protocol GamesViewControllerProtocol: ViewControllerProtocol {
    var viewModel: GamesViewModelProtocol { get }
    
    init(viewModel: GamesViewModelProtocol)
}

public protocol GameDetailsViewControllerProtocol: ViewControllerProtocol {
    var viewModel: GameDetailsViewModelProtocol { get }
    
    init(viewModel: GameDetailsViewModelProtocol)
}

public protocol GamesFiltersViewControllerProtocol: ViewControllerProtocol {
    var viewModel: GamesFiltersViewModelProtocol { get }
    
    init(viewModel: GamesFiltersViewModelProtocol)
}

public protocol GameImagesViewControllerProtocol: ViewControllerProtocol {
    var viewModel: GameImagesViewModelProtocol { get }
    
    init(viewModel: GameImagesViewModelProtocol)
}

public protocol WebViewControllerProtocol: ViewControllerProtocol {
    var viewModel: WebViewModelProtocol { get }
    
    init(viewModel: WebViewModelProtocol)
}

public protocol ImageViewerViewControllerProtocol: ViewControllerProtocol {
    var viewModel: ImageViewerViewModelProtocol { get }
    
    init(viewModel: ImageViewerViewModelProtocol)
}
