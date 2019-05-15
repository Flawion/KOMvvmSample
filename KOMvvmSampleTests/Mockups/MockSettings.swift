//
//  MockSettings.swift
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

@testable import KOMvvmSample

/// Used for sets settings of mock data in MockClient or unit tests
final class MockSettings {
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
