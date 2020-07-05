//
//  ResourceModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct ResourceModel: Codable {
    enum CodingKeys: String, CodingKey {
        case apiDetailUrl = "api_detail_url"
        case id
        case name
        case siteDetailUrl = "site_detail_url"
    }
    let apiDetailUrl: URL?
    let id: Int
    let name: String
    let siteDetailUrl: URL?
}