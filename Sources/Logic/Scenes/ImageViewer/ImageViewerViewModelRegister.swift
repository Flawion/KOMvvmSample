//
//  ImageViewerViewModelRegister.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import KOInject

struct ImageViewerViewModelRegister: ViewModelRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: ImageViewerViewModelProtocol.self, scope: .separate) { (_, appCoordinator: AppCoordinatorProtocol, image: ImageModel) in
            return ImageViewerViewModel(appCoordinator: appCoordinator, image: image)
        }
    }
}
