//
//  GamesFiltersViewModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import RxSwift
import RxCocoa

final class GamesFiltersViewModel: BaseViewModel {
    // MARK: Variables
    private let savedFiltersSubject: PublishSubject<[GamesFilters: String]> = PublishSubject<[GamesFilters: String]>()
    private let filtersVar: BehaviorRelay<[GamesFilterModel]>

    private(set) var availableSortingOptions: [GamesFilterModel]!

    var filtersObser: Observable<[GamesFilterModel]> {
        return filtersVar.asObservable()
    }

    var savedFiltersObser: Observable<[GamesFilters: String]> {
        return savedFiltersSubject.asObserver()
    }
    
    // MARK: Functions
    init(currentFilters: [GamesFilters: String]) {

        //creates filters collection
        let filterReleaseDateFrom = GamesFilterModel(filter: .originalReleaseDateFrom, value: "")
        let filterReleaseDateTo = GamesFilterModel(filter: .originalReleaseDateTo, value: "")
        let filters = [
            GamesFilterModel(filter: .sorting, value: ""),
            GamesFilterModel(filter: .platforms, value: ""),
            filterReleaseDateFrom,
            filterReleaseDateTo
        ]

        for currentFilter in currentFilters {
            //parses originalReleaseDate to two separate keys
            if currentFilter.key == .originalReleaseDate && !currentFilter.value.isEmpty {
                let datesInString = currentFilter.value.split(separator: "|")
                if datesInString.count >= 2 {
                    filterReleaseDateFrom.value = String(datesInString[0])
                    filterReleaseDateTo.value = String(datesInString[1])
                } else if currentFilter.value.starts(with: "|") {
                    filterReleaseDateTo.value = String(datesInString[0])
                } else {
                    filterReleaseDateFrom.value = String(datesInString[0])
                }
            } else if let filter = filters.first(where: { $0.filter == currentFilter.key }) {
                filter.value = currentFilter.value
            }
        }

        self.filtersVar = BehaviorRelay<[GamesFilterModel]>(value: filters)
        super.init()

        //refreshes display value for filters
        for filter in filters {
            refreshDisplayValue(filter)
        }
        createAvailableSortingOptions()
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
            refreshSortingDisplayValue(availableSortingOption)
        }
    }

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

    // MARK: Platform functions
    func selectedIndexes(forPlatformsFilter filter: GamesFilterModel) -> [IndexPath]? {
        guard !filter.value.isEmpty, PlatformsService.shared.platforms.count > 0 else {
            return nil
        }
        var indexPathes: [IndexPath] = []
        let platformsIds = filter.value.split(separator: "|")
        for platformId in platformsIds {
            if let platformIndex = PlatformsService.shared.platforms.firstIndex(where: {"\($0.id)" == platformId}) {
                indexPathes.append(IndexPath(row: platformIndex, section: 0))
            }
        }
        return indexPathes
    }

    func selectPlatforms(atIndexes indexes: [IndexPath]?, forFilter filter: GamesFilterModel) {
        defer {
            refreshDisplayValue(filter)
        }

        guard let indexes = indexes else {
            return
        }

        //refreshes filter value
        var value: String = ""
        for index in indexes where index.row < PlatformsService.shared.platforms.count {
            if !value.isEmpty {
                value += "|"
            }
            value += "\(PlatformsService.shared.platforms[index.row].id)"
        }
        filter.value = value
    }

    // MARK: Functions of refreshing filters display value
    func refreshDisplayValue(_ filter: GamesFilterModel) {
        switch filter.filter {
        case .sorting:
             refreshSortingDisplayValue(filter)

        case .originalReleaseDateTo, .originalReleaseDateFrom:
            refreshOriginalReleaseDateDisplayValue(filter)

        case .platforms:
            refreshPlatformsDisplayValue(filter)
        default:
            break
        }
    }

    private func refreshPlatformsDisplayValue(_ filter: GamesFilterModel) {
        var displayValue = ""
        let platformsIds = filter.value.split(separator: "|")
        for platformId in platformsIds {
            if let platform = PlatformsService.shared.platforms.first(where: {"\($0.id)" == platformId}) {
                if !displayValue.isEmpty {
                    displayValue += ", "
                }
                displayValue += platform.name
            }
        }
        filter.displayValue = displayValue
    }

    private func refreshOriginalReleaseDateDisplayValue(_ filter: GamesFilterModel) {
        filter.displayValue = filter.value
    }

    private func refreshSortingDisplayValue(_ filter: GamesFilterModel) {
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
}
