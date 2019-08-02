//
//  ApiDataMapperProtocol.swift
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

/// Developer can create his own mapper for data to parse data to xml or other formats
protocol ApiDataMapperProtocol: AnyObject {
    static var `default`: ApiDataMapperProtocol { get }
    func mapTo<MapTo: Codable>(data: Data) throws -> MapTo?
}

final class ApiDataToJsonMapper: ApiDataMapperProtocol {
    static var `default`: ApiDataMapperProtocol = {
        return ApiDataToJsonMapper()
    }()
    
    var dateFormatStrategy: JSONDecoder.DateDecodingStrategy = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return .formatted(formatter)
    }()
    
    func mapTo<MapTo: Codable>(data: Data) throws -> MapTo? {
        //create docoder
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = self.dateFormatStrategy
        
        //try decode data
        var mappedData: MapTo
        do {
            mappedData = try jsonDecoder.decode(MapTo.self, from: data)
        }
        return mappedData
    }
}
