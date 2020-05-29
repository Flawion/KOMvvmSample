//
//  ApiDataMapperProtocol.swift
//  KOMvvmSample
//
//  Copyright (c) 2019 Kuba Ostrowski
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.

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
        formatter.dateFormat =  "yyyy-MM-dd"
        
        return JSONDecoder.DateDecodingStrategy.custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let result = formatter.date(from: dateStr) {
                return result
            }
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let result = formatter.date(from: dateStr) {
                return result
            }
            
            formatter.dateFormat = "yyyy-MM-dd"
            if let result = formatter.date(from: dateStr) {
                return result
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
        })
    }()
    
    func mapTo<MapTo: Codable>(data: Data) throws -> MapTo? {
        //create docoder
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = dateFormatStrategy
        
        //try decode data
        var mappedData: MapTo
        do {
            mappedData = try jsonDecoder.decode(MapTo.self, from: data)
        }
        return mappedData
    }
}
