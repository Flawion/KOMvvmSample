//
//  GameDetailsViewControllerRegister.swift
//  KOMvvmSample
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import KOMvvmSampleLogic
import KOInject

struct GameDetailsViewControllerRegister: ViewControllerRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: GameDetailsViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, game: GameModel) in
            guard let viewModel: GameDetailsViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: game) else {
                fatalError(fatalErrorMessage)
            }
            return GameDetailsViewController(viewModel: viewModel)
        }
    }
}
