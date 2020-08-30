//
//  MockedViewController.swift
//  KOMvvmSampleLogicTests
//
//  Created by Kuba Ostrowski on 30/08/2020.
//

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
