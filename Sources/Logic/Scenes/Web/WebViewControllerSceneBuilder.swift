//
//  WebViewControllerSceneBuilder.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct WebViewControllerSceneBuilder: SceneBuilderProtocol {
    private let barTitle: String
    private var html: String

    init(barTitle: String, html: String) {
        self.barTitle = barTitle
        self.html = html
    }

    func createScene(withAppCoordinator appCoordinator: (AppCoordinatorProtocol & AppCoordinatorResouresProtocol)) -> UIViewController {
        let viewModel = WebViewModel(appCoordinator: appCoordinator, barTitle: barTitle, html: html)
        return createScene(withAppCoordinator: appCoordinator, viewModel: viewModel, type: .web)
    }
}
