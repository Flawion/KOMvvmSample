//
//  GamesFilterModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

final class GamesFilterModel {
    // MARK: Variables
    //public
    var filter: GamesFilters
    var value: String
    var displayValue: String?

    // MARK: Functions
    init(filter: GamesFilters, value: String) {
        self.filter = filter
        self.value = value
    }

    func getSortingOptionsFromValue() -> (option: GamesSortingOptions, direction: GamesSortingDirections)? {
        let sortingOptions = value.split(separator: ":")
        guard sortingOptions.count == 2, let sortingOption = GamesSortingOptions(rawValue: String(sortingOptions[0])), let directionOption = GamesSortingDirections(rawValue: String(sortingOptions[1])) else {
            return nil
        }
        return (sortingOption, directionOption)
    }
}
