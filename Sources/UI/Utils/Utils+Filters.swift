//
//  Utils+Filters.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

extension Utils {
    private var filterDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    func gamesFiltersString(fromFilters filters: [GamesFilters: String]) -> String {
        var filtersString = ""

        //order is important to match the url in mockupDataContainer
        addGameFilterIfExsists(fromFilters: filters, filter: .name, toString: &filtersString)
        addGameFilterIfExsists(fromFilters: filters, filter: .platforms, toString: &filtersString)
        addGameFilterIfExsists(fromFilters: filters, filter: .originalReleaseDate, toString: &filtersString)
        return filtersString
    }

    private func addGameFilterIfExsists(fromFilters filters: [GamesFilters: String], filter: GamesFilters, toString: inout String) {
        guard let value = filters[filter] else {
            return
        }
        if !toString.isEmpty {
            toString += ","
        }
        toString += String(format: "%@:%@", filter.rawValue, value)
    }
    
    func gamesSortingString(fromFilters filters: [GamesFilters: String]) -> String {
        guard let sortingOptions = filters[.sorting]?.split(separator: ":"), sortingOptions.count == 2 else {
            return ""
        }
        return String(format: "%@:%@", String(sortingOptions[0]), String(sortingOptions[1]))
    }
    
    func filterDateValue(forDate date: Date) -> String {
        return filterDateFormatter.string(from: date)
    }

    func filterDate(forValue value: String) -> Date? {
        return filterDateFormatter.date(from: value)
    }

    func filterDateRangeValue(from: Date?, to: Date?) -> String {
        let formatter = filterDateFormatter
        var fromStr = ""
        if let from = from {
            fromStr = formatter.string(from: from)
        }

        var toStr = ""
        if let to = to {
            toStr = formatter.string(from: to)
        }
        return filterDateRangeValue(from: fromStr, to: toStr)
    }

    func filterDateRangeValue(from: String, to: String) -> String {
        if !from.isEmpty || !to.isEmpty {
            return String(format: "%@|%@", from, to)
        } else {
            return ""
        }
    }
}
