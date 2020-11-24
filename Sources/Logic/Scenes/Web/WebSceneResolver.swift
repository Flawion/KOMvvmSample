//
//  WebSceneResolver.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOInject

struct WebSceneResolver: SceneResolverProtocol {
    let barTitle: String
    let url: URL?
    let html: String?
    
    init(barTitle: String, html: String) {
        self.barTitle = barTitle
        self.html = html
        self.url = nil
    }
    
    init(barTitle: String, url: URL) {
        self.barTitle = barTitle
        self.url = url
        self.html = nil
    }
    
    func resolve(withAppCoordinator appCoordinator: AppCoordinatorProtocol, resolver: KOIResolverProtocol) -> UIViewController {
        if let url = url {
            guard let viewController: WebViewControllerProtocol = resolver.resolve(arg1: appCoordinator, arg2: barTitle, arg3: url) else {
                fatalError(fatalErrorMessage)
            }
            return viewController
        }
        if let html = html {
            guard let viewController: WebViewControllerProtocol = resolver.resolve(arg1: appCoordinator, arg2: barTitle, arg3: html) else {
                fatalError(fatalErrorMessage)
            }
            return viewController
        }
        fatalError(fatalErrorMessage)
    }
}
