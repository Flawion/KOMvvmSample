//
//  GameImagesViewControllerRegister.swift
//  KOMvvmSample
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import KOMvvmSampleLogic
import KOInject

struct GameImagesViewControllerRegister: ViewControllerRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: GameImagesViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, images: [ImageModel]) in
            guard let viewModel: GameImagesViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: images) else {
                fatalError(fatalErrorMessage)
            }
            return GameImagesViewController(viewModel: viewModel)
        }
    }
}
