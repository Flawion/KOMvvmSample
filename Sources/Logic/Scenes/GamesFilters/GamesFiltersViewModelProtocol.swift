//
//  GamesFiltersViewModelProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import RxSwift
import RxCocoa

protocol GamesFiltersViewModelProtocol: ViewModelProtocol {
    var disposeBag: DisposeBag { get }
    var availableSortingOptions: [GamesFilterModel]! { get }
    var availableSortingOptionsDisplayValues: [String] { get }
    var filtersObservable: Observable<[GamesFilterModel]> { get }
    var savedFiltersObservable: Observable<[GamesFilters: String]> { get }
    var platformsDriver: Driver<[PlatformModel]> { get }
    var platforms: [PlatformModel] { get }
    var isDownloadingPlatformsDriver: Driver<Bool> { get }
    var refreshPlatformsIfNeedObservable: Observable<Void> { get }
    
    func refreshPlatformsIfNeed()
    func selectedIndexes(forPlatformsFilter filter: GamesFilterModel) -> [IndexPath]?
    func selectPlatforms(atIndexes indexes: [IndexPath]?, forFilter filter: GamesFilterModel)
    func filter(atIndexPath indexPath: IndexPath) -> GamesFilterModel?
    func saveFilters()
    func refreshDisplayValue(forFilter filter: GamesFilterModel)
}
