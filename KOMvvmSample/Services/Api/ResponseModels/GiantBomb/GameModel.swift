//
//  GamesModel.swift
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

final class GameModel: Codable {
    enum CodingKeys: String, CodingKey {
        case aliases
        case apiDetailUrl = "api_detail_url"
        case dateAdded = "date_added"
        case dateLastUpdated = "date_last_updated"
        case deck
        case description
        case expectedReleaseDay = "expected_release_day"
        case expectedReleaseMonth = "expected_release_month"
        case expectedReleaseQuarter = "expected_release_quarter"
        case expectedReleaseYear = "expected_release_year"
        case guid
        case id
        case image
        case imageTags = "image_tags"
        case name
        case numberOfUserReviews = "number_of_user_reviews"
        case originalGameRating = "original_game_rating"
        case originalReleaseDate = "original_release_date"
        case platforms
        case siteDetailUrl = "site_detail_url"
    }
    
    let aliases: String?
    let apiDetailUrl: URL?
    let dateAdded: Date
    let dateLastUpdated: Date?
    let deck: String?
    let description: String?
    let expectedReleaseDay: Int?
    let expectedReleaseMonth: Int?
    let expectedReleaseQuarter: Int?
    let expectedReleaseYear: Int?
    let guid: String
    let id: Int
    let image: ImageModel?
    let imageTags: [ImageTagModel]?
    let name: String
    let numberOfUserReviews: Int
    let originalGameRating: [ResourceModel]?
    let originalReleaseDate: Date?
    let platforms: [PlatformShortModel]?
    let siteDetailUrl: URL?
}

extension GameModel {
    var originalReleaseDateString: String? {
        guard let originalReleaseDate = originalReleaseDate else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "MMMM dd, yyyy"
        let dateString = formatter.string(from: originalReleaseDate)
        return String(format: "%@ %@", "game_details_release_date".localized, dateString)
    }
}
