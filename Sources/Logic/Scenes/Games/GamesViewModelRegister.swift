//
//  GamesViewModelRegister.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import KOInject

struct GamesViewModelRegister: ViewModelRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: GamesViewModelProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol) in
            guard let giantBombClient: GiantBombClientServiceProtocol = resolver.resolve() else {
                fatalError(fatalErrorMessage)
            }
            let searchGamesUseCase = SearchGamesUseCase(giantBombClient: giantBombClient)
            return GamesViewModel(appCoordinator: appCoordinator, searchGamesUseCase: searchGamesUseCase)
        }
    }
}
