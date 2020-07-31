//
//  ImageViewerViewModelProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public protocol ImageViewerViewModelProtocol: ViewModelProtocol {
    var image: ImageModel { get }
    
    func change(dataActionState: DataActionStates)
}
