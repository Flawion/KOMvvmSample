//
//  BaseViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa

enum ViewModelDataStates {
    case none
    case loading
    case loadingMore
    case error
    case empty
}

class BaseViewModel {
    
    // MARK: Variables
    private var dataStateVar: BehaviorRelay<ViewModelDataStates> = BehaviorRelay<ViewModelDataStates>(value: .none)
    private var raiseErrorSubject: PublishSubject<Error> = PublishSubject<Error>()

    //public
    var dataState: ViewModelDataStates {
        get {
            return dataStateVar.value
        }
        set {
            dataStateVar.accept(newValue)
        }
    }

    var raiseErrorDriver: Driver<Error> {
        return raiseErrorSubject.asDriver(onErrorJustReturn: AppErrors.driverDefault)
    }
    
    //flags
    var isDataStateNone: Bool {
        return dataState == .none
    }
    
    var isDataStateLoading: Bool {
        return dataState == .loading
    }
    
    var isDataStateLoadingMore: Bool {
        return dataState == .loading
    }
    
    var isDataStateError: Bool {
        return dataState == .error
    }
    
    var isDataStateEmpty: Bool {
        return dataState == .empty
    }
    
    //drivers
    var dataStateDriver: Driver<ViewModelDataStates> {
        return dataStateVar.asDriver()
    }
    
    var isDataStateNoneDriver: Driver<Bool> {
        return dataStateDriver.map({$0 == .none})
    }
    
    var isDataStateLoadingDriver: Driver<Bool> {
        return dataStateDriver.map({$0 == .loading})
    }
    
    var isDataStateLoadingMoreDriver: Driver<Bool> {
        return dataStateDriver.map({$0 == .loadingMore})
    }
    
    var isDataStateErrorDriver: Driver<Bool> {
        return dataStateDriver.map({$0 == .error})
    }
    
    var isDataStateEmptyDriver: Driver<Bool> {
        return dataStateDriver.map({$0 == .empty})
    }
    
    // MARK: Functions
    func raiseError(_ error: Error) {
        raiseErrorSubject.onNext(error)
    }
}
