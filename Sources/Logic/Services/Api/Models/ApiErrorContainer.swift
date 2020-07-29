//
//  ApiErrorContainer.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import Alamofire

struct ApiErrorContainer: LocalizedError {
    let response: HTTPURLResponse
    let data: Any?
    let originalError: Error

    public var errorDescription: String? {
        return "\(originalError as NSError)"
    }

    init(response: HTTPURLResponse, data: Any?, originalError: Error) {
        self.response = response
        self.data = data
        self.originalError = originalError
    }
}
