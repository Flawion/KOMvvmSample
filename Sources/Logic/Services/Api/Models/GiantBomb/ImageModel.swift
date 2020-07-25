//
//  ImageModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public struct ImageModel: Codable {
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
    
    public let iconUrl: URL?
    public let mediumUrl: URL?
    public let screenUrl: URL?
    public let screenLargeUrl: URL?
    public let smallUrl: URL?
    public let superUrl: URL?
    public let thumbUrl: URL?
    public let tinyUrl: URL?
    public let original: URL?
    public let imageTags: String?
}
