//
//  GamesFiltersSceneBuilder.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct GamesFiltersSceneBuilder: SceneBuilderProtocol {
    private let currentFilters: [GamesFilters: String]

    init(currentFilters: [GamesFilters: String]) {
        self.currentFilters = currentFilters
    }

    func createScene(withServiceLocator serviceLocator: ServiceLocator) -> UIViewController {
        guard let platformsService: PlatformsServiceProtocol = serviceLocator.get(type: .platforms) else {
            fatalError("GamesFiltersSceneBuilder can't get platformsService service")
        }
        let viewModel = GamesFiltersViewModel(platformsService: platformsService, currentFilters: currentFilters)
        return GamesFiltersViewController(viewModel: viewModel)
    }
}
