//
//  MockSettings.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

@testable import KOMvvmSampleLogic

struct MockSettings {
    
    enum FileNames: String {
        case games
        case moregames
        case filteredgames
        case platforms
        case moreplatforms
        case gamedetails
    }
}
