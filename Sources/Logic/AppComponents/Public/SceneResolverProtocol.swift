//
//  BaseViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOInject

public protocol SceneResolverProtocol {
    func resolve(withAppCoordinator appCoordinator: AppCoordinatorProtocol, resolver: KOIResolverProtocol) -> UIViewController
}

extension SceneResolverProtocol {
    var fatalErrorMessage: String {
        return "Can't resolve viewController"
    }
}
