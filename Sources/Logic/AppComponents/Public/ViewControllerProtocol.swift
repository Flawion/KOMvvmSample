//
//  ViewControllerProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

public protocol ViewControllerProtocol: UIViewController {
    // this name is used instead of viewModel because UI will be use more specialized version
    var viewModelInstance: Any { get }
    
    init(viewModel: ViewModelProtocol)
}
