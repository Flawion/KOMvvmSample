//
//  WebViewModelProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public protocol WebViewModelProtocol: ViewModelProtocol {
    var barTitle: String { get }
    var html: String? { get }
    var url: URL? { get }
    
    func tryToHandle(activatedUrl url: URL) -> Bool
}
