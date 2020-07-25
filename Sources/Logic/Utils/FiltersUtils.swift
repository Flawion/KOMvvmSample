//
//  FiltersUtils.swift
//  KOMvvmSampleLogic
//
//  Created by Kuba Ostrowski on 25/07/2020.
//

import Foundation

public final class FiltersUtils {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    public init() {
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
    
    public func dateValue(forDate date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    public func date(forValue value: String) -> Date? {
        return dateFormatter.date(from: value)
    }
    
    public func dateRangeValue(from: Date?, to: Date?) -> String {
        let formatter = dateFormatter
        var fromStr = ""
        if let from = from {
            fromStr = formatter.string(from: from)
        }
        
        var toStr = ""
        if let to = to {
            toStr = formatter.string(from: to)
        }
        return dateRangeValue(from: fromStr, to: toStr)
    }
    
    public func dateRangeValue(from: String, to: String) -> String {
        if !from.isEmpty || !to.isEmpty {
            return String(format: "%@|%@", from, to)
        } else {
            return ""
        }
    }
}
