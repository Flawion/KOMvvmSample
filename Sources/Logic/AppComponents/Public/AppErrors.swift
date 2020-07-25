//
//  AppErrors.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public enum AppErrors: String, LocalizedError {
    case selfNotExists = "error_self_not_exists"
    case driverDefault = "error_driver_default"

    var errorDescription: String {
        return self.localizedDescription
    }
}
