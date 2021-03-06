//
//  UIGameImagesViewControllerProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import KOMvvmSampleLogic

protocol UIGameImagesViewControllerProtocol: GameImagesViewControllerProtocol {
    var viewModel: GameImagesViewModelProtocol { get }
    
    func goToImageViewer(forImage: ImageModel)
}
