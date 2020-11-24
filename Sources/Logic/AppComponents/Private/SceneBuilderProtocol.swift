//
//  BaseViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit
import KOInject

protocol SceneResolverProtocol {
    func resolveScene(withAppCoordinator appCoordinator: AppCoordinatorProtocol, resolver: KOIResolverProtocol) -> UIViewController
}
