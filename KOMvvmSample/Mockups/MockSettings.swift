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

    static func isFirstFileteredGameMatch(_ game: GameModel) -> Bool {
        return game.name == "Mass Effect"
    }
    
    static func isFileteredGamesMatchFilters(_ games: [GameModel]) -> Bool {
        guard games.count > 0 else {
            return false
        }

        var prevGame: GameModel?
        for game in games {
            if !isFileteredGameMatchFilter(game, prevGame: prevGame) {
                return false
            }
            prevGame = game
        }
        return true
    }

    private static func isFileteredGameMatchFilter(_ game: GameModel, prevGame: GameModel?) -> Bool {
        guard isFileteredGameMatchName(game) else {
            return false
        }
        return isFilteredGameMatchReleaseData(game, prevGame: prevGame)
    }

    private static func isFileteredGameMatchName(_ game: GameModel) -> Bool {
        return game.name.lowercased().contains("mass effect")
    }

    private static func isFilteredGameMatchReleaseData(_ game: GameModel, prevGame: GameModel?) -> Bool {
        guard let releaseDate = game.originalReleaseDate else {
            return false
        }

        return isFilteredGameReleaseDate(releaseDate, isGreaterThanInPreviouslyGame: prevGame) && isFilteredGameReleaseDateIsInFilteredRange(releaseDate)
    }

    private static func isFilteredGameReleaseDate(_ releaseDate: Date, isGreaterThanInPreviouslyGame prevGame: GameModel?) -> Bool {
        guard let prevGame = prevGame else {
            return true
        }
        guard let prevReleaseDate = prevGame.originalReleaseDate else {
            return false
        }
        return releaseDate > prevReleaseDate
    }

    private static func isFilteredGameReleaseDateIsInFilteredRange(_ releaseDate: Date) -> Bool {
        return (releaseDate >= filtedGamesFromDate &&  releaseDate <= filtedGamesToDate)
    }
}
