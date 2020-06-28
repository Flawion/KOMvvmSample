//
//  BaseDataController.swift
//  KOMvvmSample
//
//  Created by Kuba Ostrowski on 28/06/2020.
//

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
