//
//  ResourceModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public struct ResourceModel: Codable {
    enum CodingKeys: String, CodingKey {
        case apiDetailUrl = "api_detail_url"
        case id
        case name
        case siteDetailUrl = "site_detail_url"
    }
    public let apiDetailUrl: URL?
    public let id: Int
    public let name: String
    public let siteDetailUrl: URL?
}
