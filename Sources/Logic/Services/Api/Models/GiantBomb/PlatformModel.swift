//
//  PlatformModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct PlatformModel: Codable {
    enum CodingKeys: String, CodingKey {
        case aliases
        case abbreviation
        case apiDetailUrl = "api_detail_url"
        case company
        case dateAdded = "date_added"
        case dateLastUpdated = "date_last_updated"
        case deck
        case description
        case guid
        case id
        case image
        case imageTags = "image_tags"
        case installBase = "install_base"
        case name
        case onlineSupport = "online_support"
        case originalPrice = "original_price"
        case releaseDate = "release_date"
        case siteDetailUrl = "site_detail_url"
    }

    let aliases: String?
    let abbreviation: String?
    let apiDetailUrl: URL?
    let company: CompanyModel?
    let dateAdded: Date
    let dateLastUpdated: Date?
    let deck: String?
    let description: String?
    let guid: String
    let id: Int
    let image: ImageModel?
    let imageTags: [ImageTagModel]?
    let installBase: String?
    let name: String
    let onlineSupport: Bool?
    let originalPrice: String?
    let releaseDate: Date?
    let siteDetailUrl: URL?
}
