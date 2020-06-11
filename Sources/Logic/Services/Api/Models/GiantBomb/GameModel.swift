//
//  GamesModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct GameModel: Codable {
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
    var orginalOrExpectedReleaseDateString: String? {
        guard let originalReleaseDateString = originalReleaseDateString else {
            return expectedReleaseDateString
        }
        return originalReleaseDateString
    }

    private var originalReleaseDateString: String? {
        guard let originalReleaseDate = originalReleaseDate else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "MMMM dd, yyyy"
        let dateString = formatter.string(from: originalReleaseDate)
        return String(format: "%@\n%@", "game_details_release_date".localized, dateString)
    }

    private var expectedReleaseDateString: String? {
        var stringFormatString = ""
        if expectedReleaseMonth != nil {
            stringFormatString += "MMMM"
        }
        if expectedReleaseDay != nil {
            if !stringFormatString.isEmpty {
                stringFormatString += " "
            }
            stringFormatString += "dd"
        }
        if expectedReleaseYear != nil {
            if !stringFormatString.isEmpty {
                stringFormatString += ", "
            }
            stringFormatString += "yyyy"
        }

        guard !stringFormatString.isEmpty, let date = DateComponents(calendar: Calendar.current, year: expectedReleaseYear, month: expectedReleaseMonth, day: expectedReleaseDay).date else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = stringFormatString
        let dateString = formatter.string(from: date)
        return String(format: "%@\n%@", "game_details_expected_release_date".localized, dateString)
    }
}
