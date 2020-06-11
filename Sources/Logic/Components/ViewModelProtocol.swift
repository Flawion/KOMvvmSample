//
//  ViewModelProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import RxSwift
import RxCocoa

protocol ViewModelProtocol {
    var dataActionState: ViewModelDataActionStates { get }
    var dataActionStateDriver: Driver<ViewModelDataActionStates> { get }
    var raiseErrorDriver: Driver<Error> { get }
    
    func raiseError(_ error: Error)
}
