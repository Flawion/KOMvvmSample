//
//  ApiMockDataMatchOptions.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

/// Options that decide which fake data will be matched to request parameters
enum ApiMockDataMatchOptions {
    case all
    case url
    case method
    case parameters
    case headers
}
