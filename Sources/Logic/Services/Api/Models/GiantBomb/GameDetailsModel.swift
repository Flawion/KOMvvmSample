//
//  GameDetailsModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

public struct GameDetailsModel: Codable {
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
        case images
        case videos
        case characters
        case concepts
        case developers
        case themes
        case firstAppearanceCharacters = "first_appearance_characters"
        case firstAppearanceConcepts = "first_appearance_concepts"
        case firstAppearanceLocations = "first_appearance_locations"
        case firstAppearanceObjects = "first_appearance_objects"
        case firstAppearancePeople = "first_appearance_people"
        case franchises
        case genres
        case killedCharacters = "killed_characters"
        case locations
        case objects
        case people
        case publishers
        case similarGames = "similar_games"
        case reviews
    }

    public let aliases: String?
    public let apiDetailUrl: URL?
    public let dateAdded: Date?
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
    public let images: [ImageModel]?
    public let videos: [ResourceModel]?
    public let characters: [ResourceModel]?
    public let concepts: [ResourceModel]?
    public let developers: [ResourceModel]?
    public let themes: [ResourceModel]?
    public let firstAppearanceCharacters: [ResourceModel]?
    public let firstAppearanceConcepts: [ResourceModel]?
    public let firstAppearanceLocations: [ResourceModel]?
    public let firstAppearanceObjects: [ResourceModel]?
    public let firstAppearancePeople: [ResourceModel]?
    public let franchises: [ResourceModel]?
    public let genres: [ResourceModel]?
    public let killedCharacters: [ResourceModel]?
    public let locations: [ResourceModel]?
    public let objects: [ResourceModel]?
    public let people: [ResourceModel]?
    public let publishers: [ResourceModel]?
    public let reviews: [ResourceModel]?
    public let similarGames: [ResourceModel]?
}
