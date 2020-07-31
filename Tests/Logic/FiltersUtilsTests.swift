//
//  FiltersUtilsTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest

@testable import KOMvvmSampleLogic

final class FiltersUtilsTests: XCTestCase {
    
    func testGamesFiltersString() {
        let filters = [
            GamesFilters.originalReleaseDate: "2016-06-26|2020-07-31",
            GamesFilters.name: "Mass",
            GamesFilters.sorting: "original_release_date:des",
            GamesFilters.platforms: "26|123|94"
        ]
        
        let gamesString = FiltersUtils.gamesFiltersString(fromFilters: filters)
        
        XCTAssertEqual(gamesString, "name:Mass,platforms:26|123|94,original_release_date:2016-06-26|2020-07-31")
    }
    
    func testGamesFiltersStringAddOnlySome() {
        let filters = [
            GamesFilters.originalReleaseDate: "2016-06-26|2020-07-31",
            GamesFilters.name: "Mass"
        ]
        
        let gamesString = FiltersUtils.gamesFiltersString(fromFilters: filters)
        
        XCTAssertEqual(gamesString, "name:Mass,original_release_date:2016-06-26|2020-07-31")
    }
    
    func testGamesSortingString() {
        let filters = [
            GamesFilters.originalReleaseDate: "2016-06-26|2020-07-31",
            GamesFilters.name: "Mass",
            GamesFilters.sorting: "original_release_date:desc",
            GamesFilters.platforms: "26|123|94"
        ]
        
        let gamesSortingString = FiltersUtils.gamesSortingString(fromFilters: filters)
        
        XCTAssertEqual(gamesSortingString, "original_release_date:desc")
    }
    
    func testGamesSortingStringNotEnoughParams() {
        let filters = [
            GamesFilters.originalReleaseDate: "2016-06-26|2020-07-31",
            GamesFilters.name: "Mass",
            GamesFilters.sorting: "original_release_date",
            GamesFilters.platforms: "26|123|94"
        ]
        
        let gamesSortingString = FiltersUtils.gamesSortingString(fromFilters: filters)
        
        XCTAssertEqual(gamesSortingString, "")
    }
    
    func testGamesSortingStringToMuchParams() {
        let filters = [
            GamesFilters.originalReleaseDate: "2016-06-26|2020-07-31",
            GamesFilters.name: "Mass",
            GamesFilters.sorting: "original_release_date:desc:date_added",
            GamesFilters.platforms: "26|123|94"
        ]
        
        let gamesSortingString = FiltersUtils.gamesSortingString(fromFilters: filters)
        
        XCTAssertEqual(gamesSortingString, "")
    }
    
    func testDateValue() {
        let date = Calendar.current.date(from: DateComponents(year: 2017, month: 07, day: 24))!
        let dateString = FiltersUtils.dateValue(forDate: date)
        XCTAssertEqual(dateString, "2017-07-24")
    }
    
    func testDateForValue() {
        let date = Calendar.current.date(from: DateComponents(year: 2018, month: 04, day: 3))!
        let dateToTest = FiltersUtils.date(forValue: "2018-04-03")
        XCTAssertEqual(date, dateToTest)
    }
    
    func testDateRangeValue() {
        let dateFrom = Calendar.current.date(from: DateComponents(year: 2017, month: 07, day: 24))!
        let dateTo = Calendar.current.date(from: DateComponents(year: 2018, month: 04, day: 3))!
        
        let dateRangeValue = FiltersUtils.dateRangeValue(from: dateFrom, to: dateTo)
        
        XCTAssertEqual(dateRangeValue, "2017-07-24|2018-04-03")
    }
    
    func testDateRangeValueOnlyFrom() {
        let dateFrom = Calendar.current.date(from: DateComponents(year: 2019, month: 05, day: 13))!
        
        let dateRangeValue = FiltersUtils.dateRangeValue(from: dateFrom, to: nil)
        
        XCTAssertEqual(dateRangeValue, "2019-05-13|")
    }
    
    func testDateRangeValueOnlyTo() {
        let dateTo = Calendar.current.date(from: DateComponents(year: 2019, month: 05, day: 13))!
        
        let dateRangeValue = FiltersUtils.dateRangeValue(from: nil, to: dateTo)
        
        XCTAssertEqual(dateRangeValue, "|2019-05-13")
    }
    
    func testDateRangeValueNoDates() {
        let dateRangeValue = FiltersUtils.dateRangeValue(from: nil, to: nil)
        
        XCTAssertEqual(dateRangeValue, "")
    }
}
