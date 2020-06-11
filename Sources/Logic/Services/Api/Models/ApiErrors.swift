//
//  ApiErrors.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

enum ApiErrors: String, LocalizedError {
    case connection = "error_connection"
    case validation = "error_validation"

    var errorDescription: String {
        return self.rawValue.localized
    }
}
