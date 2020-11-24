//
//  GameDetailsViewModelRegister.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import KOInject

struct GameDetailsViewModelRegister: ViewModelRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: GameDetailsViewModelProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, game: GameModel) in
            guard let giantBombClient: GiantBombClientServiceProtocol = resolver.resolve() else {
                fatalError(fatalErrorMessage)
            }
            let gameDetailsUseCase = GameDetailsUseCase(game: game, giantBombClient: giantBombClient)
            return GameDetailsViewModel(appCoordinator: appCoordinator, gameDetailsUseCase: gameDetailsUseCase)
        }
    }
}
