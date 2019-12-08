//
//  ApiMockData.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct ApiMockData {
    let id: String
    let matchOptions: [ApiMockDataMatchOptions]
    let fileName: String
    let fileType: String
    let requestParameters: ApiRequestParameters
    
    init(fileName: String, fileType: String, requestParameters: ApiRequestParameters, matchOptions: [ApiMockDataMatchOptions] = [.all]) {
        id = UUID().uuidString
        self.matchOptions = matchOptions
        self.fileName = fileName
        self.fileType = fileType
        self.requestParameters = requestParameters
    }
}
