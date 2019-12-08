//
//  MockSettings+FilteredGamesValidation.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

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
