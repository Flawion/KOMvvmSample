//
//  GameImagesViewModelRegister.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import KOInject

struct GameImagesViewModelRegister: ViewModelRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: GameImagesViewModelProtocol.self, scope: .separate) { (_, appCoordinator: AppCoordinatorProtocol, images: [ImageModel]) in
            return GameImagesViewModel(appCoordinator: appCoordinator, images: images)
        }
    }
}
