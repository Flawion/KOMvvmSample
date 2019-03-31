//
//  BaseResponseModel.swift
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

class BaseResponseModel<ResultsType: Codable> : Codable {
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
