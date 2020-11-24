//
//  GamesFiltersViewModelRegister.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import KOInject

struct GamesFiltersViewModelRegister: ViewModelRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: GamesFiltersViewModelProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, currentFilters: [GamesFilters: String]) in
            guard let giantBombClient: GiantBombClientServiceProtocol = resolver.resolve(), let dataStore: DataStoreServiceProtocol = resolver.resolve() else {
                fatalError(fatalErrorMessage)
            }
            let platformsUseCase = PlatformsUseCase(giantBombClient: giantBombClient, dataStore: dataStore)
            return GamesFiltersViewModel(appCoordinator: appCoordinator, platformsUseCase: platformsUseCase, currentFilters: currentFilters)
        }
    }
}
