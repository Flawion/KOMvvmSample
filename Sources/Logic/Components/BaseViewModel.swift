//
//  BaseViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa

enum ViewModelDataActionStates {
    case none
    case loading
    case loadingMore
    case error
    case empty
}

class BaseViewModel: ViewModelProtocol {
    
    // MARK: Variables
    private var dataActionStateRelay: BehaviorRelay<ViewModelDataActionStates> = BehaviorRelay<ViewModelDataActionStates>(value: .none)
    private var raiseErrorSubject: PublishSubject<Error> = PublishSubject<Error>()
    private(set) weak var appCoordinator: AppCoordinatorProtocol?

    //public
    var dataActionState: ViewModelDataActionStates {
        get {
            return dataActionStateRelay.value
        }
        set {
            dataActionStateRelay.accept(newValue)
        }
    }
    
    var dataActionStateDriver: Driver<ViewModelDataActionStates> {
        return dataActionStateRelay.asDriver()
    }

    var raiseErrorDriver: Driver<Error> {
        return raiseErrorSubject.asDriver(onErrorJustReturn: AppErrors.driverDefault)
    }
    
    // MARK: Functions
    init(appCoordinator: AppCoordinatorProtocol) {
        self.appCoordinator = appCoordinator
    }
    
    func raiseError(_ error: Error) {
        raiseErrorSubject.onNext(error)
    }
}
