//
//  BaseResponseModel.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

import Foundation

struct BaseResponseModel<ResultsType: Codable>: Codable {
    enum CodingKeys: String, CodingKey {
        case error
        case limit
        case offset
        case numberOfPageResults = "number_of_page_results"
        case numberOfTotalResults = "number_of_total_results"
        case statusCode = "status_code"
        case version
        case results
    }
    
    let error: String
    let limit: Int
    let offset: Int
    let numberOfPageResults: Int
    let numberOfTotalResults: Int
    let statusCode: Int
    let version: String
    let results: ResultsType?
}

/*extension BaseResponseModel: LogDataRecudible {
    func reducedLogData() -> String {
        return String(format: "%@: %d, %@: %d", CodingKeys.numberOfPageResults.rawValue, numberOfPageResults, CodingKeys.numberOfTotalResults.rawValue, numberOfTotalResults)
    }
}*/
