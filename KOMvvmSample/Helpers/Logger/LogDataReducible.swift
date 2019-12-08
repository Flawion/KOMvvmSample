//
//  LogDataReducible.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

/// Can be used for model that need to be log to decide what information should be visible
protocol LogDataRecudible {
    func reducedLogData() -> String
}
