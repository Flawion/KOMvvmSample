//
//  WebViewControllerRegister.swift
//  KOMvvmSample
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import KOMvvmSampleLogic
import KOInject

struct WebViewControllerRegister: ViewControllerRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: WebViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, barTitle: String, html: String) in
            guard let viewModel: WebViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: barTitle, arg3: html) else {
                fatalError(fatalErrorMessage)
            }
            return WebViewController(viewModel: viewModel)
        }
        
        register.register(forType: WebViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, barTitle: String, url: URL) in
            guard let viewModel: WebViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: barTitle, arg3: url) else {
                fatalError(fatalErrorMessage)
            }
            return WebViewController(viewModel: viewModel)
        }
    }
}
