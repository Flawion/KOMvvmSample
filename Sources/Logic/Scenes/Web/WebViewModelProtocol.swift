//
//  WebViewModelProtocol.swift
//  KOMvvmSample
//
//  Created by Kuba Ostrowski on 11/06/2020.
//

import Foundation

protocol WebViewModelProtocol: ViewModelProtocol {
    var barTitle: String { get }
    var html: String? { get }
    var url: URL? { get }
    
    func openLink(_ url: URL)
}