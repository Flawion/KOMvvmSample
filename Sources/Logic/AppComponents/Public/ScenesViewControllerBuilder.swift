//
//  ScenesViewControllerBuilder.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

public final class ScenesViewControllerBuilder {
    private var viewControllerForTypes: [SceneTypes: UIViewController.Type] = [:]
    
    public func register(viewControllerType: UIViewController.Type, forType type: SceneTypes) {
        viewControllerForTypes[type] = viewControllerType
    }
    
    func get(forViewModel viewModel: ViewModelProtocol, type: SceneTypes) -> ViewControllerProtocol? {
        guard let viewControllerType = viewControllerForTypes[type] as? ViewControllerProtocol.Type else {
            return nil
        }
        return viewControllerType.init(viewModel: viewModel)
    }
}