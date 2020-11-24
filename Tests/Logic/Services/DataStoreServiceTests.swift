//
//  DataStoreServiceTests.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import XCTest

@testable import KOMvvmSampleLogic

final class DataStoreServiceTests: XCTestCase {
    
    private var dataStore: DataStoreServiceProtocol!
    
    override func setUp() {
        dataStore = DataStoreService()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        dataStore.platforms = nil
        dataStore = nil
        guard let testDataStore = (dataStore as? TestDataStoreServiceProtocol) else {
            return
        }
        testDataStore.testUserDefaultObject = nil
        testDataStore.testUserDefaultBool = nil
    }
    
    func testSavePlatforms() {
        guard let platforms: BaseResponseModel<[PlatformModel]>? = jsonModel(mockName: .platforms) else {
            XCTAssertTrue(false)
            return
        }
        
        dataStore.platforms = platforms?.results
        
        XCTAssertNotNil(dataStore.platforms)
        XCTAssertNotNil(dataStore.savePlatformsDate)
        XCTAssertEqual(dataStore.platforms?.count, platforms?.results?.count)
    }
    
    func testDeletePlatforms() {
        guard let platforms: BaseResponseModel<[PlatformModel]>? = jsonModel(mockName: .platforms) else {
            XCTAssertTrue(false)
            return
        }
        dataStore.platforms = platforms?.results
        
        dataStore.platforms = nil
        
        XCTAssertNil(dataStore.platforms)
        XCTAssertNil(dataStore.savePlatformsDate)
    }
    
    func testSaveUserDefaultObject() {
        guard let testDataStore = dataStore as? TestDataStoreServiceProtocol else {
            XCTAssertTrue(false)
            return
        }
        let testData = TestUserDefaultObject(name: "Kuba", value: "Ostr", age: 30)
        
        testDataStore.testUserDefaultObject = testData
        let savedDate = testDataStore.testUserDefaultObject
        
        XCTAssertNotNil(savedDate)
        XCTAssertEqual(savedDate?.name, testData.name)
        XCTAssertEqual(savedDate?.value, testData.value)
        XCTAssertEqual(savedDate?.age, testData.age)
    }
    
    func testClearUserDefaultObject() {
        guard let testDataStore = dataStore as? TestDataStoreServiceProtocol else {
            XCTAssertTrue(false)
            return
        }
        let testData = TestUserDefaultObject(name: "Kuba", value: "Ostr", age: 30)
        
        testDataStore.testUserDefaultObject = testData
        testDataStore.testUserDefaultObject = nil
        
        XCTAssertNil(testDataStore.testUserDefaultObject)
    }
    
    func testGetNotContainedUserDefaultBool() {
        guard let testDataStore = dataStore as? TestDataStoreServiceProtocol else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertNil(testDataStore.testUserDefaultBool)
    }
    
    func testSaveUserDefaultBool() {
        guard let testDataStore = dataStore as? TestDataStoreServiceProtocol else {
            XCTAssertTrue(false)
            return
        }
        let saveUserDefaultBool = true
        
        testDataStore.testUserDefaultBool = saveUserDefaultBool
        
        XCTAssertEqual(testDataStore.testUserDefaultBool, saveUserDefaultBool)
    }
    
    func testClearUserDefaultBool() {
        guard let testDataStore = dataStore as? TestDataStoreServiceProtocol else {
            XCTAssertTrue(false)
            return
        }
        
        testDataStore.testUserDefaultBool = true
        testDataStore.testUserDefaultBool = nil
        
        XCTAssertNil(testDataStore.testUserDefaultBool)
    }
}
