//
//  ViewModelRegisterProtocol.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import KOInject

protocol ViewModelRegisterProtocol {
    func register(register: KOIRegisterProtocol)
}

extension ViewModelRegisterProtocol {
    var fatalErrorMessage: String {
        return "AppCoordinator doesn't exist or components not registered"
    }
}
