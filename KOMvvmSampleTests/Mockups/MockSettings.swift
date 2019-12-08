//
//  MockSettings.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

@testable import KOMvvmSample

/// Used for sets settings of mock data in MockClient or unit tests
struct MockSettings {
    static var responseDelay: Double {
        return 0.1
    }

    static var filtedGamesName: String {
        return "Mass effect"
    }

    static var filtedGamesToDate: Date {
        return Calendar.current.date(from: DateComponents(year: 2019, month: 3, day: 8))!
    }

    static var filtedGamesFromDate: Date {
        return Calendar.current.date(from: DateComponents(year: 2006, month: 3, day: 3))!
    }

    static var filteredGamesFilters: [GamesFilters: String] {
        return [GamesFilters.name: filtedGamesName, GamesFilters.sorting: String(format: "%@:%@", GamesSortingOptions.originalReleaseDate.rawValue, GamesSortingDirections.asc.rawValue), GamesFilters.originalReleaseDate: Utils.shared.filterDateRangeValue(from: filtedGamesFromDate, to: filtedGamesToDate)]
    }

    static var platformsTotalCount: Int {
        return 157
    }
}
