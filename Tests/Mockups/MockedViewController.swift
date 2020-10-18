//
//  MockedViewController.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import UIKit

@testable import KOMvvmSampleLogic

final class MockedViewController: UIViewController, ViewControllerProtocol {
    let viewModelInstance: Any
      
    init(viewModel: ViewModelProtocol) {
        viewModelInstance = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
