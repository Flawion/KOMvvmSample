//
//  AppErrors+Creating.swift
//  KOMvvmSampleLogic
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public enum AppErrorCodes: Int {
    case commonSelfNotExists = 100
    case commonDriverDefault = 101
    
    case apiConnection = 201
    case apiValidation = 202
}

// MARK: Creating
extension AppError {
    public static var commonSelfNotExists: NSError {
        return AppError(withCode: .commonSelfNotExists)
    }
    
    public static var commonDriverDefault: NSError {
        return AppError(withCode: .commonDriverDefault)
    }
    
    public static var apiConnection: NSError {
        return AppError(withCode: .apiConnection, description: "error_connection".localized)
    }
    
    public static var apiValidation: NSError {
        return AppError(withCode: .apiValidation, description: "error_validation".localized)
    }
}
