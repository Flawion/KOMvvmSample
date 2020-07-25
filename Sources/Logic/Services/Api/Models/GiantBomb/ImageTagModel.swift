//
//  ImageTagModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public struct ImageTagModel: Codable {
    enum CodingKeys: String, CodingKey {
        case apiDetailUrl = "api_detail_url"
        case name
        case total
    }
    
    public let apiDetailUrl: URL?
    public let name: String?
    public let total: Int?
}
