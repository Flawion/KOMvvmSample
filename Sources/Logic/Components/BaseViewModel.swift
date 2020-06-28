//
//  BaseViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa

enum DataActionStates {
    case none
    case loading
    case loadingMore
    case error
    case empty
}

class BaseViewModel: BaseDataController, ViewModelProtocol {
    
    // MARK: Variables
    private(set) weak var appCoordinator: AppCoordinatorProtocol?
    
    // MARK: Functions
    init(appCoordinator: AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }
    
    func forward(dataControllerState dataController: BaseDataController, disposeBag: DisposeBag) {
        dataController.dataActionStateDriver.drive(onNext: { [weak self] dataActionState in
            self?.dataActionState = dataActionState
        }).disposed(by: disposeBag)
        
        dataController.raiseErrorDriver.drive(onNext: { [weak self] error in
            self?.raise(error: error)
        }).disposed(by: disposeBag)
    }
}
