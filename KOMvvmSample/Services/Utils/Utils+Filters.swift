//
//  Utils+Filters.swift
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
