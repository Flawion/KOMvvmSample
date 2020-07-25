//
//  GamesFilters.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public enum GamesFilters: String {
    case name
    case platforms
    case originalReleaseDate = "original_release_date"
    case originalReleaseDateFrom
    case originalReleaseDateTo
    case sorting

    public var localizable: String {
        switch self {
        case .sorting:
            return "games_filters_sorting".localized
        case .platforms:
            return "games_filters_platforms".localized
        case .originalReleaseDateFrom:
            return "games_filters_release_from".localized
        case .originalReleaseDateTo:
            return "games_filters_release_to".localized

        default:
            return ""
        }
    }
}
