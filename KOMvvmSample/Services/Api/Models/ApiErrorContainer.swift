//
//  ApiError.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Alamofire

struct ApiErrorContainer: LocalizedError {
    let response: HTTPURLResponse
    let data: Any?
    let originalError: Error

    var errorDescription: String {
        return originalError.localizedDescription
    }

    init(response: HTTPURLResponse, data: Any?, originalError: Error) {
        self.response = response
        self.data = data
        self.originalError = originalError
    }
}
