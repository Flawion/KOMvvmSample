//
//  GamesFiltersViewModelTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2020 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import XCTest
import RxSwift
import RxCocoa
import RxBlocking

@testable import KOMvvmSampleLogic

final class GamesFiltersViewModelTests: XCTestCase {
    private var appCoordinator: MockedAppCoordinator!
    private var gamesFiltersViewModel: GamesFiltersViewModel!
    
    private var allPlatforms: [PlatformModel] {
        guard let response: BaseResponseModel<[PlatformModel]> = jsonModel(mockName: .platforms), let responsePlatforms = response.results,
            let responseMore: BaseResponseModel<[PlatformModel]> = jsonModel(mockName: .moreplatforms), let responseMorePlatforms = responseMore.results else {
                return []
        }
        return responsePlatforms + responseMorePlatforms
    }
    
    override func setUp() {
        appCoordinator = MockedAppCoordinator()
        let giantBombMockClient: GiantBombClientServiceProtocol = appCoordinator.mockGiantBombClientServiceConfigurator.client
        let dataStore: DataStoreServiceProtocol = appCoordinator.mockDataStoreServiceConfigurator.dataStore
        let platformsUseCase = PlatformsUseCase(giantBombClient: giantBombMockClient, dataStore: dataStore)
        
        gamesFiltersViewModel = GamesFiltersViewModel(appCoordinator: appCoordinator, platformsUseCase: platformsUseCase, currentFilters: appCoordinator.mockGiantBombClientServiceConfigurator.searchFilters)
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        appCoordinator = nil
        gamesFiltersViewModel = nil
    }
    
    func testInit() {
        let expectedReleaseDateFromValue =  FiltersUtils.dateValue(forDate: appCoordinator.mockGiantBombClientServiceConfigurator.searchFilteredGamesFromDate)
        let expectedReleaseDateToValue =  FiltersUtils.dateValue(forDate: appCoordinator.mockGiantBombClientServiceConfigurator.searchFilteredGamesToDate)
        let expectedSorting = appCoordinator.mockGiantBombClientServiceConfigurator.searchFilteredGamesSortingOptions
        let filters = (try? gamesFiltersViewModel.filtersObservable.toBlocking().first()) ?? []
        
        XCTAssertNil(filters.first(where: { $0.filter == .name }))
        XCTAssertEqual(filters.first(where: { $0.filter == .originalReleaseDateFrom })?.value, expectedReleaseDateFromValue)
        XCTAssertEqual(filters.first(where: { $0.filter == .originalReleaseDateTo })?.value, expectedReleaseDateToValue)
        XCTAssertEqual(filters.first(where: { $0.filter == .platforms })?.value, "" )
        XCTAssertEqual(filters.first(where: { $0.filter == .sorting })?.value, expectedSorting)
    }
    
    func testFilterAtIndexPath() {
         let filters = (try? gamesFiltersViewModel.filtersObservable.toBlocking().first()) ?? []
        
        for index in 0..<filters.count {
            let filterAtIndex = gamesFiltersViewModel.filter(atIndexPath: IndexPath(row: index, section: 0))
            XCTAssertEqual(filterAtIndex?.filter, filters[index].filter)
            XCTAssertEqual(filterAtIndex?.value, filters[index].value)
        }
        XCTAssertNil(gamesFiltersViewModel.filter(atIndexPath: IndexPath(row: -1, section: 0)))
        XCTAssertNil(gamesFiltersViewModel.filter(atIndexPath: IndexPath(row: filters.count + 1, section: 0)))
    }
    
    func testDownloadPlatformsIfNeed() {
        gamesFiltersViewModel.refreshPlatformsIfNeed()
        XCTAssertTrue((try? gamesFiltersViewModel.isDownloadingPlatformsDriver.toBlocking().first()) ?? false)
        try? gamesFiltersViewModel.refreshPlatformsIfNeedObservable.toBlocking().first()
        
        let platforms = (try? gamesFiltersViewModel.platformsDriver.toBlocking().first()) ?? []
        XCTAssertFalse((try? gamesFiltersViewModel.isDownloadingPlatformsDriver.toBlocking().first()) ?? false)
        let allPlatforms = self.allPlatforms
        XCTAssertFalse(gamesFiltersViewModel.platforms.contains(where: { platform in !allPlatforms.contains(where: { $0.id == platform.id }) }))
        XCTAssertFalse(platforms.contains(where: { platform in !allPlatforms.contains(where: { $0.id == platform.id }) }))
    }
    
    func testSelectedIndexesForPlatformsFilter() {
        try? gamesFiltersViewModel.refreshPlatformsIfNeedObservable.toBlocking().first()
        let expectedPlatformsIndexes: [IndexPath] = [
            IndexPath(row: gamesFiltersViewModel.platforms.firstIndex(where: { $0.id == 156 }) ?? 0, section: 0),
            IndexPath(row: gamesFiltersViewModel.platforms.firstIndex(where: { $0.id == 52 }) ?? 0, section: 0),
            IndexPath(row: gamesFiltersViewModel.platforms.firstIndex(where: { $0.id == 60 }) ?? 0, section: 0)
        ]
        
        let platformsIndexes = gamesFiltersViewModel.selectedIndexes(forPlatformsFilter: GamesFilterModel(filter: .platforms, value: "156|52|60")) ?? []
        
        XCTAssertFalse(platformsIndexes.contains(where: { indexPath in !expectedPlatformsIndexes.contains(indexPath) })  )
    }
    
    func testSelectPlatformsForIndexes() {
        try? gamesFiltersViewModel.refreshPlatformsIfNeedObservable.toBlocking().first()
        let expectedPlatformsIndexes: [IndexPath] = [
            IndexPath(row: gamesFiltersViewModel.platforms.firstIndex(where: { $0.id == 156 }) ?? 0, section: 0),
            IndexPath(row: gamesFiltersViewModel.platforms.firstIndex(where: { $0.id == 52 }) ?? 0, section: 0),
            IndexPath(row: gamesFiltersViewModel.platforms.firstIndex(where: { $0.id == 60 }) ?? 0, section: 0)
        ]
        
        let gamesFilter = GamesFilterModel(filter: .platforms, value: "")
        gamesFiltersViewModel.selectPlatforms(atIndexes: expectedPlatformsIndexes, forFilter: gamesFilter)

        XCTAssertEqual(gamesFilter.displayValue, String(format: "%@, %@, %@", gamesFiltersViewModel.platforms[expectedPlatformsIndexes[0].row].name,
            gamesFiltersViewModel.platforms[expectedPlatformsIndexes[1].row].name,
            gamesFiltersViewModel.platforms[expectedPlatformsIndexes[2].row].name))
        XCTAssertEqual(gamesFilter.value, "156|52|60")
    }
    
    func testSelectDateForFilter() {
        let date = Calendar.current.date(from: DateComponents(year: 2010, month: 2, day: 24))!
        
        let gamesFilter = GamesFilterModel(filter: .originalReleaseDateTo, value: "")
        gamesFiltersViewModel.select(date: date, forFilter: gamesFilter)
        
        XCTAssertEqual(gamesFilter.value, "2010-02-24")
        XCTAssertEqual(gamesFilter.value, gamesFilter.displayValue)
    }
    
    func testDateFromFilter() {
        let filterValue = "2015-08-11"
        let expectedDate = FiltersUtils.date(forValue: filterValue)
        
        let dateFromFilterValue = gamesFiltersViewModel.date(fromFilterValue: filterValue)
        
        XCTAssertEqual(dateFromFilterValue, expectedDate)
    }
    
    func testSaveFilters() {
        let disposeBag = DisposeBag()
        try? gamesFiltersViewModel.refreshPlatformsIfNeedObservable.toBlocking().first()
        let filters = (try? gamesFiltersViewModel.filtersObservable.toBlocking().first()) ?? []
        let expectedDateFromString = "2014-07-21"
        let expectedDateFrom = FiltersUtils.date(forValue: expectedDateFromString)!
        let expectedDateToString = "2018-11-16"
        let expectedDateString = String(format: "%@|%@", expectedDateFromString, expectedDateToString)
        let expectedDateTo = FiltersUtils.date(forValue: expectedDateToString)!
        let expectedSorting = String(format: "%@:%@", GamesSortingOptions.name.rawValue, GamesSortingDirections.desc.rawValue)
        let expectedPlatformsIndexes: [IndexPath] = [
            IndexPath(row: gamesFiltersViewModel.platforms.firstIndex(where: { $0.id == 156 }) ?? 0, section: 0),
            IndexPath(row: gamesFiltersViewModel.platforms.firstIndex(where: { $0.id == 52 }) ?? 0, section: 0),
            IndexPath(row: gamesFiltersViewModel.platforms.firstIndex(where: { $0.id == 60 }) ?? 0, section: 0)
        ]
        guard let dateFromFilter = filters.first(where: { $0.filter == .originalReleaseDateFrom }),
            let dateToFilter = filters.first(where: { $0.filter == .originalReleaseDateTo }),
            let platformsFilter = filters.first(where: { $0.filter == .platforms }),
            let sortingFilter = filters.first(where: { $0.filter == .sorting }) else {
            XCTAssertTrue(false)
            return
        }
        let saveFiltersExpection = expectation(description: "save filters")
        
        gamesFiltersViewModel.select(date: expectedDateFrom, forFilter: dateFromFilter)
        gamesFiltersViewModel.select(date: expectedDateTo, forFilter: dateToFilter)
        gamesFiltersViewModel.selectPlatforms(atIndexes: expectedPlatformsIndexes, forFilter: platformsFilter)
        sortingFilter.value = expectedSorting
        gamesFiltersViewModel.refreshDisplayValue(forFilter: platformsFilter)
        
        gamesFiltersViewModel.savedFiltersObservable.subscribe(onNext: { filters in
            XCTAssertEqual(filters.first(where: { $0.key == .originalReleaseDate })?.value, expectedDateString)
            XCTAssertEqual(filters.first(where: { $0.key == .sorting })?.value, expectedSorting)
            XCTAssertEqual(filters.first(where: { $0.key == .platforms })?.value, "156|52|60")
            saveFiltersExpection.fulfill()
            }).disposed(by: disposeBag)
        gamesFiltersViewModel.saveFilters()
        
        waitForExpectations(timeout: 1)
    }
}
