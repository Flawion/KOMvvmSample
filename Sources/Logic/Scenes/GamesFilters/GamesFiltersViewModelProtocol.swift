//
//  GamesFiltersViewModelProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import RxSwift
import RxCocoa

protocol GamesFiltersViewModelProtocol: ViewModelProtocol {
    var platformsService: PlatformsServiceProtocol! { get }
    var availableSortingOptions: [GamesFilterModel]! { get }
    var availableSortingOptionsDisplayValues: [String] { get }
    var filtersObser: Observable<[GamesFilterModel]> { get }
    var savedFiltersObser: Observable<[GamesFilters: String]> { get }
    
    func selectedIndexes(forPlatformsFilter filter: GamesFilterModel) -> [IndexPath]?
    func selectPlatforms(atIndexes indexes: [IndexPath]?, forFilter filter: GamesFilterModel)
    func filter(atIndexPath indexPath: IndexPath) -> GamesFilterModel?
    func saveFilters()
    func refreshDisplayValue(forFilter filter: GamesFilterModel)
}
