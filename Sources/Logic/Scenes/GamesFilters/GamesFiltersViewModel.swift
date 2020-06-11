//
//  GamesFiltersViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import RxSwift
import RxCocoa

final class GamesFiltersViewModel: BaseViewModel {
    // MARK: Variables
    private let savedFiltersSubject: PublishSubject<[GamesFilters: String]> = PublishSubject<[GamesFilters: String]>()
    private let filtersVar: BehaviorRelay<[GamesFilterModel]> = BehaviorRelay<[GamesFilterModel]>(value: [])
    
    private(set) var platformsService: PlatformsServiceProtocol!
    private(set) var availableSortingOptions: [GamesFilterModel]!
    
    // MARK: Functions
    init(appCoordinator: AppCoordinatorProtocol, platformsService: PlatformsServiceProtocol, currentFilters: [GamesFilters: String]) {
        self.platformsService = platformsService
        super.init(appCoordinator: appCoordinator)
        
        createFiltersCollection(fromCurrentFilters: currentFilters)
        createAvailableSortingOptions()
    }
    
    private func createFiltersCollection(fromCurrentFilters currentFilters: [GamesFilters: String]) {
        let filterReleaseDateFrom = GamesFilterModel(filter: .originalReleaseDateFrom, value: "")
        let filterReleaseDateTo = GamesFilterModel(filter: .originalReleaseDateTo, value: "")
        let filters = [
            GamesFilterModel(filter: .sorting, value: ""),
            GamesFilterModel(filter: .platforms, value: ""),
            filterReleaseDateFrom,
            filterReleaseDateTo
        ]
        
        for currentFilter in currentFilters {
            if currentFilter.key == .originalReleaseDate && !currentFilter.value.isEmpty {
                parseFilterOriginalReleaseDate(value: currentFilter.value, andUpdateFilterReleaseDateFrom: filterReleaseDateFrom, filterReleaseDateTo: filterReleaseDateTo)
            } else if let filter = filters.first(where: { $0.filter == currentFilter.key }) {
                filter.value = currentFilter.value
            }
        }
        refreshDisplayValue(forFilters: filters)
        filtersVar.accept(filters)
    }
    
    private func parseFilterOriginalReleaseDate(value: String, andUpdateFilterReleaseDateFrom filterReleaseDateFrom: GamesFilterModel, filterReleaseDateTo: GamesFilterModel) {
        let datesInString = value.split(separator: "|")
        if datesInString.count >= 2 {
            filterReleaseDateFrom.value = String(datesInString[0])
            filterReleaseDateTo.value = String(datesInString[1])
        } else if value.starts(with: "|") {
            filterReleaseDateTo.value = String(datesInString[0])
        } else {
            filterReleaseDateFrom.value = String(datesInString[0])
        }
    }
    
    private func createAvailableSortingOptions() {
        availableSortingOptions = [
            GamesFilterModel(filter: .sorting, value: String(format: "%@:%@", GamesSortingOptions.originalReleaseDate.rawValue, GamesSortingDirections.desc.rawValue)),
            GamesFilterModel(filter: .sorting, value: String(format: "%@:%@", GamesSortingOptions.originalReleaseDate.rawValue, GamesSortingDirections.asc.rawValue)),
            GamesFilterModel(filter: .sorting, value: String(format: "%@:%@", GamesSortingOptions.name.rawValue, GamesSortingDirections.desc.rawValue)),
            GamesFilterModel(filter: .sorting, value: String(format: "%@:%@", GamesSortingOptions.name.rawValue, GamesSortingDirections.asc.rawValue)),
            GamesFilterModel(filter: .sorting, value: String(format: "%@:%@", GamesSortingOptions.dateAdded.rawValue, GamesSortingDirections.desc.rawValue)),
            GamesFilterModel(filter: .sorting, value: String(format: "%@:%@", GamesSortingOptions.dateAdded.rawValue, GamesSortingDirections.asc.rawValue))
        ]
        for availableSortingOption in availableSortingOptions {
            refreshSortingDisplayValue(forFilter: availableSortingOption)
        }
    }
}

// MARK: - GamesFiltersViewModelProtocol
extension GamesFiltersViewModel: GamesFiltersViewModelProtocol {
    
    var availableSortingOptionsDisplayValues: [String] {
        return availableSortingOptions.compactMap({ $0.displayValue })
    }
    
    var filtersObser: Observable<[GamesFilterModel]> {
        return filtersVar.asObservable()
    }
    
    var savedFiltersObser: Observable<[GamesFilters: String]> {
        return savedFiltersSubject.asObserver()
    }
    
    // MARK: Platform functions
    func selectedIndexes(forPlatformsFilter filter: GamesFilterModel) -> [IndexPath]? {
        guard !filter.value.isEmpty, platformsService.platforms.count > 0 else {
            return nil
        }
        var indexPathes: [IndexPath] = []
        let platformsIds = filter.value.split(separator: "|")
        for platformId in platformsIds {
            if let platformIndex = platformsService.platforms.firstIndex(where: {"\($0.id)" == platformId}) {
                indexPathes.append(IndexPath(row: platformIndex, section: 0))
            }
        }
        return indexPathes
    }
    
    func selectPlatforms(atIndexes indexes: [IndexPath]?, forFilter filter: GamesFilterModel) {
        defer {
            refreshDisplayValue(forFilter: filter)
        }
        
        guard let indexes = indexes else {
            return
        }
        
        //refreshes filter value
        var value: String = ""
        for index in indexes where index.row < platformsService.platforms.count {
            if !value.isEmpty {
                value += "|"
            }
            value += "\(platformsService.platforms[index.row].id)"
        }
        filter.value = value
    }
    
    // MARK: Filters
    func filter(atIndexPath indexPath: IndexPath) -> GamesFilterModel? {
        guard indexPath.count < filtersVar.value.count else {
            return nil
        }
        return filtersVar.value[indexPath.row]
    }
    
    func saveFilters() {
        var filters: [GamesFilters: String] = [:]
        
        var dateValueFrom: String = ""
        var dateValueTo: String = ""
        for filter in filtersVar.value {
            if filter.filter == GamesFilters.originalReleaseDateFrom {
                dateValueFrom = filter.value
            } else if filter.filter == GamesFilters.originalReleaseDateTo {
                dateValueTo = filter.value
            } else {
                filters[filter.filter] = filter.value
            }
        }
        filters[GamesFilters.originalReleaseDate] = Utils.shared.filterDateRangeValue(from: dateValueFrom, to: dateValueTo)
        savedFiltersSubject.onNext(filters)
    }
    
    // MARK: Functions of refreshing filters display value
    func refreshDisplayValue(forFilter filter: GamesFilterModel) {
        switch filter.filter {
        case .sorting:
            refreshSortingDisplayValue(forFilter: filter)
            
        case .originalReleaseDateTo, .originalReleaseDateFrom:
            refreshOriginalReleaseDateDisplayValue(forFilter: filter)
            
        case .platforms:
            refreshPlatformsDisplayValue(forFilter: filter)
        default:
            break
        }
    }
    
    private func refreshSortingDisplayValue(forFilter filter: GamesFilterModel) {
        guard let sortingOptions = filter.getSortingOptionsFromValue() else {
            return
        }
        
        let isAscending = sortingOptions.direction == .asc
        switch sortingOptions.option {
        case .dateAdded:
            filter.displayValue = (isAscending ? "games_filters_sorting_date_added_asc" : "games_filters_sorting_date_added_desc").localized
        case .name:
            filter.displayValue = (isAscending ? "games_filters_sorting_name_asc" : "games_filters_sorting_name_desc").localized
        case .originalReleaseDate:
            filter.displayValue = (isAscending ? "games_filters_sorting_release_date_asc" : "games_filters_sorting_release_date_desc").localized
        }
    }
    
    private func refreshOriginalReleaseDateDisplayValue(forFilter filter: GamesFilterModel) {
        filter.displayValue = filter.value
    }
    
    private func refreshPlatformsDisplayValue(forFilter filter: GamesFilterModel) {
        var displayValue = ""
        let platformsIds = filter.value.split(separator: "|")
        for platformId in platformsIds {
            if let platform = platformsService.platforms.first(where: {"\($0.id)" == platformId}) {
                if !displayValue.isEmpty {
                    displayValue += ", "
                }
                displayValue += platform.name
            }
        }
        filter.displayValue = displayValue
    }
    
    private func refreshDisplayValue(forFilters filters: [GamesFilterModel]) {
        for filter in filters {
            refreshDisplayValue(forFilter: filter)
        }
    }
}
