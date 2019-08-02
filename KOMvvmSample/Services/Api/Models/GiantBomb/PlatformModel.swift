//
//  PlatformModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

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
