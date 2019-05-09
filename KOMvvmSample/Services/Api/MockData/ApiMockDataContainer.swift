//
//  ApiMockData.swift
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

/// Contains fake data for MockClient
final class ApiMockDataContainer {
    // MARK: Variables
    private(set) var mockData: [ApiMockData] = []
    
    /// Bundle from which data will be loaded
    var loadDataFromBundleIdentifier: String?
    
    var dataBundle: Bundle {
        var bundle = Bundle.main
        if let bundleIdentifier = loadDataFromBundleIdentifier, let newBundle = Bundle(identifier: bundleIdentifier) {
            bundle = newBundle
        }
        return bundle
    }
    
    // MARK: Public access to collection
    func mockData(forRequestParameters requestParameters: ApiRequestParameters) -> [ApiMockData] {
        var matchedMockData: [ApiMockData] = []
        for data in mockData where checkIsMockData(data, matchRequestParameters: requestParameters) {
            matchedMockData.append(data)
        }
        return matchedMockData
    }
    
    func loadMockData(forRequestParameters requestParameters: ApiRequestParameters) -> Data? {
        guard let mockData = mockData(forRequestParameters: requestParameters).first,
            let dataUrl = dataBundle.url(forResource: mockData.fileName, withExtension: mockData.fileType) else {
            return nil
        }
        return try? Data.init(contentsOf: dataUrl)
    }
    
    func register(mockData: ApiMockData) {
        guard mockDataIndex(withId: mockData.id) == nil else {
            return
        }
        self.mockData.append(mockData)
    }
    
    func unregister(mockId: String) {
        guard let indexOfMock = mockDataIndex(withId: mockId) else {
            return
        }
        mockData.remove(at: indexOfMock)
    }
    
    // MARK: Equality functions
    private func checkIsMockData(_ mockData: ApiMockData, matchRequestParameters requestParameters: ApiRequestParameters) -> Bool {
        let allNeedToMach = mockData.matchOptions.contains(.all)
        
        //checks equality of urls
        if mockData.matchOptions.contains(.url) || allNeedToMach {
            if mockData.requestParameters.url != requestParameters.url {
                return false
            }
        }
        
        //checks equality of methods
        if mockData.matchOptions.contains(.method) || allNeedToMach {
            if mockData.requestParameters.method != requestParameters.method {
                return false
            }
        }
        
        //checks equality of parameters
        if mockData.matchOptions.contains(.parameters) || allNeedToMach {
            if !checkEqualityOfParameters(mockData.requestParameters.parameters, withParameters: requestParameters.parameters) {
                return false
            }
        }
        
        //checks equality of headers
        if mockData.matchOptions.contains(.headers) || allNeedToMach {
            if !checkEqualityOfHeaders(mockData.requestParameters.headers, withHeaders: requestParameters.headers) {
                return false
            }
        }
        return true
    }
    
    private func checkEqualityOfParameters(_ dataParameters: [String: Any]?, withParameters: [String: Any]?) -> Bool {
        let dataParameters = dataParameters ?? [:]
        let parameters = withParameters ?? [:]
        var matchedParametersCount: Int = 0
        
        for dataParameter in dataParameters {
            guard let parameter = parameters[dataParameter.key] else {
                break
            }
            if  isParameter(dataParameter.value, equalToParameter: parameter) {
                matchedParametersCount += 1
                continue
            }
            break
        }
        return matchedParametersCount == dataParameters.count
    }
    
    private func checkEqualityOfHeaders(_ dataHeaders: [String: String]?, withHeaders: [String: String]?) -> Bool {
        let dataHeaders = dataHeaders ?? [:]
        let headers = withHeaders ?? [:]
        var matchedHeadersCount: Int = 0
        
        for dataHeader in dataHeaders {
            guard let header = headers[dataHeader.key], header == dataHeader.value else {
                break
            }
            matchedHeadersCount += 1
        }
        return matchedHeadersCount == dataHeaders.count
    }
    
    private func isParameter(_ parameter: Any, equalToParameter: Any) -> Bool {
        if isEqual(type: Int.self, value: parameter, withValue: equalToParameter) ||
            isEqual(type: UInt.self, value: parameter, withValue: equalToParameter) ||
            isEqual(type: String.self, value: parameter, withValue: equalToParameter) ||
            isEqual(type: Float.self, value: parameter, withValue: equalToParameter) ||
            isEqual(type: Double.self, value: parameter, withValue: equalToParameter) ||
            isEqual(type: Decimal.self, value: parameter, withValue: equalToParameter) {
            return true
        }
        return false
    }
    
    private func isEqual<T: Equatable>(type: T.Type, value: Any, withValue: Any) -> Bool {
        guard let value = value as? T, let withValue = withValue as? T else {
            return false
            
        }
        return value == withValue
    }
    
    private func mockDataIndex(withId mockId: String) -> Int? {
        return mockData.firstIndex(where: {$0.id == mockId})
    }
}
