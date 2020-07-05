//
//  ImageTagModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct ImageTagModel: Codable {
    enum CodingKeys: String, CodingKey {
        case apiDetailUrl = "api_detail_url"
        case name
        case total
    }
    
    let apiDetailUrl: URL?
    let name: String?
    let total: Int?
}