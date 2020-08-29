//
//  GamesModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public struct GameModel: Codable {
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
    
    public let aliases: String?
    public let apiDetailUrl: URL?
    public let dateAdded: Date
    public let dateLastUpdated: Date?
    public let deck: String?
    public let description: String?
    public let expectedReleaseDay: Int?
    public let expectedReleaseMonth: Int?
    public let expectedReleaseQuarter: Int?
    public let expectedReleaseYear: Int?
    public let guid: String
    public let id: Int
    public let image: ImageModel?
    public let imageTags: [ImageTagModel]?
    public let name: String
    public let numberOfUserReviews: Int
    public let originalGameRating: [ResourceModel]?
    public let originalReleaseDate: Date?
    public let platforms: [PlatformShortModel]?
    public let siteDetailUrl: URL?
    
    public init(testModelWithGuid guid: String, name: String) {
        self.dateAdded = Date()
        self.guid = guid
        self.id = -1
        self.name = name
        self.numberOfUserReviews = 0
        self.aliases = nil
        self.apiDetailUrl = nil
        self.dateLastUpdated = nil
        self.deck = nil
        self.description = nil
        self.expectedReleaseDay = nil
        self.expectedReleaseMonth = nil
        self.expectedReleaseQuarter = nil
        self.expectedReleaseYear = nil
        self.image = nil
        self.imageTags = nil
        self.originalGameRating = nil
        self.originalReleaseDate = nil
        self.platforms = nil
        self.siteDetailUrl = nil
    }
}

extension GameModel {
    public var orginalOrExpectedReleaseDateString: String? {
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
