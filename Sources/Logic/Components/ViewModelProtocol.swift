//
//  ViewModelProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import RxSwift
import RxCocoa

protocol ViewModelProtocol {
    var dataActionState: DataActionStates { get }
    var dataActionStateDriver: Driver<DataActionStates> { get }
    var raiseErrorDriver: Driver<Error> { get }
    
    func raise(error: Error)
}
