//
//  AppErrorsTest.swift
//  KOMvvmSampleLogicTests
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

import XCTest
import UIKit

@testable import KOMvvmSampleLogic

final class AppErrorsTest: XCTestCase {
    
    func testErrorGeneralDescription() {
        let appErrorCode = AppError.Codes.commonSelfNotExists
        let expectedDescription = "error_general\n(app \(appErrorCode.rawValue))"
        
        let error = AppError(withCode: appErrorCode)
        XCTAssertEqual(error.errorDescription, expectedDescription)
    }
    
    func testIndividualErrorDescription() {
        let appErrorCode = AppError.Codes.apiMapping
        let expectedDescription = "error_parse\n(app \(appErrorCode.rawValue))"
        
        let error = AppError(withCode: appErrorCode)
        XCTAssertEqual(error.errorDescription, expectedDescription)
    }
    
    func testCreateApiError() {
        guard let response = HTTPURLResponse(url: URL(string: "https://www.google.pl/")!, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: [:]) else {
            XCTAssertTrue(false)
            return
        }
        let dataString = "test data"

        let error = AppError.apiError(withCode: .apiValidation, forResponse: response, data: dataString.data(using: .utf8), originalError: nil)
        
        XCTAssertTrue(error.userInfo[AppError.UserInfoKeys.apiResponse.rawValue] as? HTTPURLResponse === response)
        guard let errorData = (error.userInfo[AppError.UserInfoKeys.apiData.rawValue] as? Data), let errorDataString = String(data: errorData, encoding: .utf8) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(dataString, errorDataString)
    }
    
    func testErrorDescriptionWithInnerError() {
        let appErrorCode = AppError.Codes.commonSelfNotExists
        let innerError = NSError(domain: "pl.test.domain", code: 2, userInfo: nil)
        let expectedDescription = "error_general\n(\(innerError.domain.split(separator: ".").last!) \(innerError.code))"
        
        let error = AppError(withCode: appErrorCode, innerError: innerError)
        XCTAssertEqual(error.errorDescription, expectedDescription)
    }
}
