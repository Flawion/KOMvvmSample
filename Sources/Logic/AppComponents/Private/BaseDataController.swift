//
//  BaseDataController.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa

class BaseDataController {
    // MARK: Variables
    private var dataActionStateRelay: BehaviorRelay<DataActionStates> = BehaviorRelay<DataActionStates>(value: .none)
    private var raiseErrorSubject: PublishSubject<Error> = PublishSubject<Error>()
    
    //public
    var dataActionState: DataActionStates {
        get {
            return dataActionStateRelay.value
        }
        set {
            dataActionStateRelay.accept(newValue)
        }
    }
    
    var dataActionStateDriver: Driver<DataActionStates> {
        return dataActionStateRelay.asDriver()
    }
    
    var raiseErrorDriver: Driver<Error> {
        return raiseErrorSubject.asDriver(onErrorJustReturn: AppErrors.driverDefault)
    }
    
    func raise(error: Error) {
        raiseErrorSubject.onNext(error)
    }
}
