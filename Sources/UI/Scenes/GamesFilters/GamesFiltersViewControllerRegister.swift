//
//  GamesFiltersViewControllerRegister.swift
//  KOMvvmSample
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import KOMvvmSampleLogic
import KOInject

struct GamesFiltersViewControllerRegister: ViewControllerRegisterProtocol {
    func register(register: KOIRegisterProtocol) {
        register.register(forType: GamesFiltersViewControllerProtocol.self, scope: .separate) { (resolver, appCoordinator: AppCoordinatorProtocol, currentFilters: [GamesFilters: String]) in
            guard let viewModel: GamesFiltersViewModelProtocol = resolver.resolve(arg1: appCoordinator, arg2: currentFilters) else {
                fatalError(fatalErrorMessage)
            }
            return GamesFiltersViewController(viewModel: viewModel)
        }
    }
}
