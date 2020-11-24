//
//  GamesViewControllerRegister.swift
//  KOMvvmSample
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import KOMvvmSampleLogic
import KOInject

struct GamesViewControllerRegister: ViewControllerRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: GamesViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol) in
            guard let viewModel: GamesViewModelProtocol = resolver.resolve(arg1: appCoordinator) else {
                fatalError(fatalErrorMessage)
            }
            return GamesViewController(viewModel: viewModel)
        }
    }
}
