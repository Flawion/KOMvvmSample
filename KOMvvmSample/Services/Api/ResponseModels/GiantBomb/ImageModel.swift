//
//  ImageModel.swift
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

final class ImageModel: Codable {
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
