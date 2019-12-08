//
//  ImageModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct ImageModel: Codable {
    enum CodingKeys: String, CodingKey {
        case iconUrl = "icon_url"
        case mediumUrl = "medium_url"
        case screenUrl = "screen_url"
        case screenLargeUrl = "screen_large_url"
        case smallUrl = "small_url"
        case superUrl = "super_url"
        case thumbUrl = "thumb_url"
        case tinyUrl  = "tiny_url"
        case original
        case imageTags = "image_tags"
    }
    
    let iconUrl: URL?
    let mediumUrl: URL?
    let screenUrl: URL?
    let screenLargeUrl: URL?
    let smallUrl: URL?
    let superUrl: URL?
    let thumbUrl: URL?
    let tinyUrl: URL?
    let original: URL?
    let imageTags: String?
}
