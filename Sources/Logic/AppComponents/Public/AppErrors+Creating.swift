//
//  AppErrors+Creating.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

// MARK: Creating
extension AppError {
    public enum Codes: Int {
        case commonSelfNotExists = 100
        case commonDriverDefault = 101
        
        case apiConnection = 201
        case apiValidation = 202
        case apiMapping = 203
    }
    
    public enum UserInfoKeys: String {
        case apiResponse // HTTPURLResponse
        case apiData // Data
    }
    
    static func createDescriptionKeysForErrorCodes() -> [AppError.Codes: String] {
        return [.apiConnection: "error_connection",
                .apiValidation: "error_validation",
                .apiMapping: "error_parse"
                ]
    }
    
    static func apiError(withCode code: AppError.Codes, forResponse response: HTTPURLResponse, data: Any?, originalError: Error?) -> AppError {
        var userInfo: [String: Any] = [AppError.UserInfoKeys.apiResponse.rawValue: response]
        if let data = data {
            userInfo[AppError.UserInfoKeys.apiData.rawValue] = data
        }
        return AppError(withCode: code, userInfo: userInfo, innerError: originalError as NSError?)
    }
}
