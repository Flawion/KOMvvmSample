//
//  GameImagesViewControllerProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift

protocol GameImagesViewControllerProtocol: NSObjectProtocol {
    var viewModel: GameImagesViewModel { get }
    
    func goToImageViewer(forImage: ImageModel)
}
