//
//  MockSettings+FilteredGamesValidation.swift
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
import XCTest

@testable import KOMvvmSample

extension MockSettings {

    static func isFirstFileteredGameMatch(_ game: GameModel) {
        XCTAssert(game.name == "Mass Effect")
    }

    static func isFileteredGamesMatchFilters(_ games: [GameModel]) {
        guard games.count > 0 else {
            return
        }

        var prevGame: GameModel?
        for game in games {
            isFileteredGameMatchFilter(game, prevGame: prevGame)
            prevGame = game
        }
    }

    private static func isFileteredGameMatchFilter(_ game: GameModel, prevGame: GameModel?) {
        isFileteredGameMatchName(game)
        isFilteredGameMatchReleaseData(game, prevGame: prevGame)
    }

    private static func isFileteredGameMatchName(_ game: GameModel) {
        XCTAssert(game.name.lowercased().contains("mass effect"))
    }

    private static func isFilteredGameMatchReleaseData(_ game: GameModel, prevGame: GameModel?) {
        guard let releaseDate = game.originalReleaseDate else {
            return
        }

        isFilteredGameReleaseDate(releaseDate, isGreaterThanInPreviouslyGame: prevGame)
        isFilteredGameReleaseDateIsInFilteredRange(releaseDate)
    }

    private static func isFilteredGameReleaseDate(_ releaseDate: Date, isGreaterThanInPreviouslyGame prevGame: GameModel?) {
        guard let prevGame = prevGame else {
            return
        }
        guard let prevReleaseDate = prevGame.originalReleaseDate else {
            return
        }
        XCTAssert(releaseDate > prevReleaseDate)
    }

    private static func isFilteredGameReleaseDateIsInFilteredRange(_ releaseDate: Date) {
        XCTAssert(releaseDate >= filtedGamesFromDate &&  releaseDate <= filtedGamesToDate)
    }

}
