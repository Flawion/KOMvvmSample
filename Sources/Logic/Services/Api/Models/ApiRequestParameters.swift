//
//  ApiRequestParameters.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation
import Alamofire

struct ApiRequestParameters {
    let url: URL
    let method: HTTPMethod
    let parameters: [String: Any]?
    let headers: [String: String]?
    let encoding: ParameterEncoding?
    
    init(url: URL, method: HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, encoding: ParameterEncoding? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.encoding = encoding
    }
}
