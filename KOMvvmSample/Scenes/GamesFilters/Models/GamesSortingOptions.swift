//
//  GamesSortingOptions.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

enum GamesSortingOptions: String {
    case name
    case dateAdded = "date_added"
    case originalReleaseDate = "original_release_date"
}

enum GamesSortingDirections: String {
    case desc
    case asc
}
