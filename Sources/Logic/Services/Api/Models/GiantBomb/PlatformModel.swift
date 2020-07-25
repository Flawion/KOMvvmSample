//
//  PlatformModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public struct PlatformModel: Codable {
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

    public let aliases: String?
    public let abbreviation: String?
    public let apiDetailUrl: URL?
    public let company: CompanyModel?
    public let dateAdded: Date
    public let dateLastUpdated: Date?
    public let deck: String?
    public let description: String?
    public let guid: String
    public let id: Int
    public let image: ImageModel?
    public let imageTags: [ImageTagModel]?
    public let installBase: String?
    public let name: String
    public let onlineSupport: Bool?
    public let originalPrice: String?
    public let releaseDate: Date?
    public let siteDetailUrl: URL?
}
