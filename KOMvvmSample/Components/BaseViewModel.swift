//
//  BaseViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

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
