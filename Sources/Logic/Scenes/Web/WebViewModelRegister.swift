//
//  WebViewModelRegister.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import KOInject

struct WebViewModelRegister: ViewModelRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: WebViewModelProtocol.self, scope: .separate) { (_, appCoordinator: AppCoordinatorProtocol, barTitle: String, html: String) in
            return WebViewModel(appCoordinator: appCoordinator, barTitle: barTitle, html: html)
        }
        
        register.register(forType: WebViewModelProtocol.self, scope: .separate) { (_, appCoordinator: AppCoordinatorProtocol, barTitle: String, url: URL) in
            return WebViewModel(appCoordinator: appCoordinator, barTitle: barTitle, url: url)
        }
    }
}
