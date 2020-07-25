//
//  AppSettings.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct AppSettings {
}

extension AppSettings {
    struct Api {

        // Insert your api key here
        static var key: String {
            return ""
        }

        static var giantBombAddress: String {
            return "https://www.giantbomb.com"
        }
    }

    struct Games {
        static var defaultFilters: [GamesFilters: String] {
            return [GamesFilters.sorting: String(format: "%@:%@", GamesSortingOptions.originalReleaseDate.rawValue, GamesSortingDirections.desc.rawValue), GamesFilters.originalReleaseDate: FiltersUtils().dateRangeValue(from: nil, to: Date())]
        }

        static var limitPerRequest: Int {
            return 24
        }
    }

    struct Platforms {
        static var limitPerRequest: Int {
            return 100
        }

        static var cacheOnDiscForMinutes: Int {
            return 1440
        }
    }
}
